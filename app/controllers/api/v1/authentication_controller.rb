module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: {
              id: user.id,
              email: user.email,
              organization_id: user.organization_id,
              role: user.role
            }
          }, status: :ok
        else
          render json: {error: "Invalid email or password"}, status: :unauthorized
        end
      end
    end
  end
end
