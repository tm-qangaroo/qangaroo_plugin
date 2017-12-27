module Api
  module V1
    class Api::V1::QangarooServicesController < ApplicationController
      skip_before_action :authenticate_user!
      skip_before_action :verify_authenticity_token, if: :json_request?
      before_action :authenticate_key, except: [:verify_qangaroo_plugin]
      before_action :load_service, only: [:delete_service, :register_issue, :update_issue, :get_updated_issues]
      respond_to :json

      def verify_qangaroo_plugin
        @redmine_version = Redmine::Info.versioned_name.match(/(\d.\d.\d)/)[1]
        @plugin = Redmine::Plugin.find(:qangaroo_plugin)
        ssl = request.ssl? ? true : false
        if @plugin
          send_response(200, {plugin: @plugin, redmine_version: @redmine_version, ssl: ssl})
        else
          send_response("Plugin not found.")
        end
      end

      def create_service
        qangaroo_fields = JSON.parse(request.headers["X-Qangaroo-Fields"])
        if @service = QangarooService.find_by(namespace: qangaroo_fields["namespace"])
          @service.verify_and_update(qangaroo_fields)
        else
          @service = QangarooService.new(name: qangaroo_fields["name"], api_key: qangaroo_fields["api_key"], namespace: qangaroo_fields["namespace"])
          unless @service.save!
            send_response(@service.errors.full_messages)
          end
        end
        send_response(200)
      end

      def delete_service
        if @service.present?
          @service.update_attributes(active: false)
          send_response(200)
        else
          send_response("Redmine側の連携設定が見つかりませんでした。")
        end
      end

      def provide_projects
        @projects = Project.visible.sorted.joins(:trackers).group("projects.id")
        send_response(200, @projects)
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
        send_response(200, @field_instances)
      end

      def register_issue
        @issue = Issue.new(issue_params)
        @issue.assign_attributes(status: IssueStatus.try(:first)) if @issue.status_id.nil?
        return send_response(l(:closed_project)) if @issue.project.closed?
        return send_response(l(:unauthorized_user)) unless authorize_user
        if @issue.save
          @qangaroo_issue = @service.qangaroo_issues.build(qangaroo_issue_params)
          if @qangaroo_issue.save
            send_response(200, {"id" => @qangaroo_issue.id, "updated" => @qangaroo_issue.updated_at})
          else
            send_response(@qangaroo_issue.errors.full_messages)
          end
        else
          send_response(@issue.errors.full_messages)
        end
      end

      def update_issue
        data = params.require(:qangaroo_issue)
        @qangaroo_issue = @service.qangaroo_issues.find_by(qangaroo_bug_id: data["bugId"], qangaroo_project_id: data["qangarooProjectId"])
        @issue = @qangaroo_issue.issue
        return send_response(l(:closed_project)) if @issue.project.closed?
        return send_response(l(:unauthorized_user)) unless authorize_user
        @issue.assign_attributes(issue_params)
        if @issue.save
          @qangaroo_issue.update_attributes(updated_at: @issue.updated_on)
          send_response(200, {"id" => @qangaroo_issue.id, "updated" => @qangaroo_issue.updated_at})
        else
          send_response(@issue.errors.full_messages)
        end
      end

      def get_updated_issues
        @qangaroo_issues = @service.qangaroo_issues.where(qangaroo_bug_id: params["id"])
        results = {}
        @qangaroo_issues.each { |qi| results[qi.id] = qi.issue }
        send_response(200, results)
      end

      private
      def issue_params
        params.require(:issue).permit(:projectId, :issueTypeId, :statusId, :summary, :priorityId, :description, :dueDate, :assigneeId).merge(author_id: @reporter.try(:id) || @user.try(:id))
      end

      def qangaroo_issue_params
        params.require(:qangaroo_issue).permit(:bugId, :qangarooProjectId).merge(issue_id: @issue.id, project_id: @issue.project.id, updated_at: @issue.updated_on)
      end

      def load_service
        qangaroo_fields = JSON.parse(request.headers["X-Qangaroo-Fields"])
        if @service = QangarooService.find_by(namespace: qangaroo_fields["namespace"])
          @service.verify_and_update(qangaroo_fields)
          if key = qangaroo_fields["personal_key"]
            @reporter = User.find_by_api_key(key)
          end
        else
          send_response("Service not found.") if @service.nil?
        end
      end

      def authorize_user
        return @user.allowed_to?(:add_issues, @issue.project, global: true) ? true : false
      end

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

      def send_response(status, body=nil)
        render json: {status: status, body: body}
      end

    end
  end
end
