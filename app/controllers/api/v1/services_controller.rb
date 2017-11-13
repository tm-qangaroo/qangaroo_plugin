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
        @projects = Project.visible.sorted.joins(:trackers).group("projects.id")
        render json: @projects
      end

      def get_redmine_fields
        @project = Project.find(params[:id])
        @field_instances = {}
        eligible_fields = ["IssueStatus", "IssuePriority", "Tracker"]
        eligible_fields.each do |eligible_field|
          if eligible_field == "Tracker"
            @field_instances[eligible_field] = @project.trackers
          else
            @field_instances[eligible_field] = Module.const_get(eligible_field).all
          end
        end
        render json: @field_instances
      end

      def register_issue
        data = params
        @issue = Issue.new(
          project_id: data["projectId"], #連携先のプロジェクト
          tracker_id: data["issueTypeId"],
          status_id: data["statusId"] || IssueStatus.first.try(:id), #新規
          author_id: @user.id,
          subject: data["summary"], #タイトル
          priority_id: data["priorityId"],
          description: data["description"],
          due_date: data["dueDate"],
        )
        if @issue.save
          @qangaroo_issue = QangarooIssue.new(issue_id: @issue.id, project_id: @issue.project.id, qangaroo_bug_id: data["bugId"], qangaroo_project_id: data["qangarooProjectId"], updated_at: @issue.updated_on)
          if @qangaroo_issue.save
            signal_status({"id" => @qangaroo_issue.id, "updated" => @qangaroo_issue.updated_at})
          else
            signal_status(@issue.errors.full_messages)
          end
        else
          signal_status(@issue.errors.full_messages)
        end
      end

      def update_issue
        data = params
        @qangaroo_issue = QangarooIssue.find_by(qangaroo_bug_id: data["bugId"], qangaroo_project_id: data["qangarooProjectId"])
        @issue = @qangaroo_issue.issue
        @issue.assign_attributes(
          tracker_id: data["issueTypeId"] || @issue.tracker_id,
          status_id: data["statusId"] || @issue.status_id,
          subject: data["summary"] || @issue.subject,
          priority_id: data["priorityId"] || @issue.priority_id,
          description: data["description"] || @issue.description,
          due_date: data["dueDate"] || @issue.due_date,
        )
        if @issue.save
          @qangaroo_issue.update_attributes(updated_at: @issue.updated_on)
          signal_status({"id" => @qangaroo_issue.id, "updated" => @qangaroo_issue.updated_at})
        else
          signal_status(@issue.errors.full_messages)
        end
      end

      def get_updated_issues
        qangaroo_issues = QangarooIssue.all
        results = {}
        qangaroo_issues.each { |qi| results[qi.id] = qi.issue }
        render json: results
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
          signal_status("Successful Connection")
        end
      end

      def delete_service
        qangaroo_fields = JSON.parse(request.headers["X-Qangaroo-Fields"])
        @service = Service.find_by(api_key: qangaroo_fields["api_key"], namespace: qangaroo_fields["namespace"])
        if @service.destroy
          signal_status("Successful Connection")
        end
      end

      def signal_status(msg=true)
        render json: {'status': msg}
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
