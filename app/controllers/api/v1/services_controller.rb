module Api
  module V1
    class Api::V1::ServicesController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :authenticate_key, except: [:verify_qangaroo_plugin]
      respond_to :json

      def verify_qangaroo_plugin
        @redmine_version = Redmine::Info.versioned_name.match(/(\d.\d.\d)/)[1]
        @plugin = Redmine::Plugin.find(:qangaroo_plugin)
        render json: {"plugin": @plugin, "redmine_version": @redmine_version}
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

      def delete_service
        qangaroo_fields = JSON.parse(request.headers["X-Qangaroo-Fields"])
        @service = Service.find_by(api_key: qangaroo_fields["api_key"], namespace: qangaroo_fields["namespace"])
        if @service.destroy
          signal_success("Successful Connection")
        end
      end

      def signal_success(msg=true)
        render json: {'status_ok': msg}
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
    end
  end
end
