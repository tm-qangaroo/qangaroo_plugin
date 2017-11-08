module Api
  module V1
    class Api::V1::ServicesController < ApplicationController
      skip_before_action :authenticate_user!
      skip_before_action :verify_authenticity_token, if: :json_request?
      before_action :authenticate_key, except: [:verify_qangaroo_plugin]
      respond_to :json

      def verify_qangaroo_plugin
        @redmine_version = Redmine::Info.versioned_name.match(/(\d.\d.\d)/)[1]
        @plugin = Redmine::Plugin.find(:qangaroo_plugin)
        render json: {"plugin": @plugin, "redmine_version": @redmine_version}
      end

      def provide_projects
        @projects = Project.visible.sorted
        @project_hash = {}
        @projects.map { |proj| @project_hash[proj.id] = proj }
        render json: @project_hash
      end

      def get_redmine_fields
        @field_instances = {}
        eligible_fields = ["IssueStatus", "IssuePriority", "Tracker"]
        eligible_fields.each do |eligible_field|
          @field_instances[eligible_field] = Module.const_get(eligible_field).all
        end
        render json: @field_instances
      end

      def register_issue
        data = params.values.first
        @issue = Issue.new(
          project_id: data["projectId"].first, #連携先のプロジェクト
          tracker_id: data["issueTypeId"].second,
          status_id: 1, #新規
          author_id: @user.id,
          subject: data["summary"].second, #タイトル
        )
        if @issue.save
          @qangaroo_issue = QangarooIssue.new(issue_id: @issue.id, project_id: @issue.project.id, qangaroo_bug_id: data["bugId"].second, qangaroo_project_id: params.keys.first)
          if @qangaroo_issue.save
            signal_success("登録できました。")
          else
            signal_error(@issue.errors.full_messages)
          end
        else
          signal_error(@issue.errors.full_messages)
        end
      end

      def create_service
        qangaroo_fields = JSON.parse(request.headers["X-Qangaroo-Fields"])
        @service = Service.find_by(api_key: qangaroo_fields["api_key"], namespace: qangaroo_fields["namespace"])
        if @service.nil?
          @service = Service.new(
            name: qangaroo_fields["name"],
            api_key: qangaroo_fields["api_key"],
            namespace: qangaroo_fields["namespace"],
          )
        end
        if @service.save!
          signal_success("Successful Connection")
        end
      end

      def delete_service
        qangaroo_fields = JSON.parse(request.headers["X-Qangaroo-Fields"])
        @service = Service.find_by(api_key: qangaroo_fields["api_key"], namespace: qangaroo_fields["namespace"])
        if @service.destroy
          signal_success("Successful Connection")
        end
      end

      def signal_success(msg=true)
        render json: {'status': msg}
      end

      def signal_error(msg=true)
        render json: {'error': msg}
      end

      private
      def authenticate_key
        key = request.headers['X-Redmine-API-Key']
        if key
          @user = User.find_by_api_key(key)
          if @user.nil?
            return unauthorize
          end
        else
          return unauthorize
        end
      end

      def unauthorize
        head status: :unauthorized
        return false
      end

      def json_request?
        request.format = :json unless request.format.json?
        return request.format.json?
      end
    end
  end
end
