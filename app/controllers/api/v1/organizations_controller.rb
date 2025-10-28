module Api
  module V1
    class OrganizationsController < BaseController
      skip_before_action :authenticate_request, only: [:index, :show]

      def index
        @organizations = Organization.all
        render json: @organizations
      end

      def show
        @organization = Organization.find(params[:id])
        render json: @organization
      end
    end
  end
end
