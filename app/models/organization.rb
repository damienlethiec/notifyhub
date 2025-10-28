class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :sent_notifications, class_name: "Notification", foreign_key: "from_organization_id", dependent: :destroy
  has_many :received_notifications, class_name: "Notification", foreign_key: "to_organization_id", dependent: :destroy

  validates :name, presence: true
  validates :siret, presence: true, uniqueness: true, length: {is: 14}
end
