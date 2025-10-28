module Api
  module V1
    class NotificationsController < BaseController
      # Exercice 1 : Optimiser les requêtes et ajouter la pagination
      def index
        @notifications = Notification
          .where(to_organization_id: current_user.organization_id)
          .order(created_at: :desc)

        render :index
      end

      # Exercice 2 : Vérifier les autorisations d'accès
      def show
        @notification = Notification.find(params[:id])

        render :show
      end

      # Exercice 3 : Extraire la logique métier et rendre l'envoi asynchrone
      def create
        @notification = Notification.new(notification_params)

        if @notification.save
          @notification.to_organization.users.each do |user|
            NotificationMailer.new_notification(user, @notification).deliver_now
          end

          @notification.update!(status: "sent")

          render :show, status: :created
        else
          render json: {errors: @notification.errors}, status: :unprocessable_entity
        end
      end

      # Exercice 4 : Implémenter l'endpoint mark_as_read
      # POST /api/v1/notifications/:id/mark_as_read

      private

      def notification_params
        params.require(:notification).permit(:title, :body, :to_organization_id, :from_organization_id, :priority, :attachment)
      end
    end
  end
end
