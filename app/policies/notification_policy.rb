class NotificationPolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.present?
  end
end
