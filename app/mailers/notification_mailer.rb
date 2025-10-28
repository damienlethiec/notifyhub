class NotificationMailer < ApplicationMailer
  def new_notification(user, notification)
    @user = user
    @notification = notification

    mail to: user.email,
         subject: "Nouvelle notification : #{notification.title}"
  end
end
