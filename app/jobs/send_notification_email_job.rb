class SendNotificationEmailJob < ApplicationJob
  queue_as :default

  def perform(user_id, notification_id)
    user = User.find(user_id)
    notification = Notification.find(notification_id)

    NotificationMailer.new_notification(user, notification).deliver_now
  end
end
