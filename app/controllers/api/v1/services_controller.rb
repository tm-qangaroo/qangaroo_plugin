module Api
  module V1
    class Api::V1::ServicesController < ApplicationController
      skip_before_action :authenticate_user!
      before_action :authenticate_key, except: [:verify_qangaroo_plugin]
      respond_to :json

      def verify_qangaroo_plugin
        @plugin = Redmine::Plugin.find(:qangaroo_plugin)
        render json: @plugin
      end

      private
      def authenticate_key
        key = request.headers['X-API-KEY']
        if api_key
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
