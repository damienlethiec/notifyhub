module Api
  module V1
    class BaseController < ApplicationController
      include Authenticable
      include Pundit::Authorization

      before_action :set_default_format

      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

      private

      def set_default_format
        request.format = :json
      end

      def user_not_authorized
        render json: {error: "You are not authorized to perform this action."}, status: :forbidden
      end
    end
  end
end
