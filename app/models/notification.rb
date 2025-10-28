class Notification < ApplicationRecord
  belongs_to :from_organization, class_name: "Organization"
  belongs_to :to_organization, class_name: "Organization"
  has_one_attached :attachment

  validates :title, presence: true
  validates :body, presence: true
  validates :status, inclusion: {in: %w[pending sent read]}
  validates :priority, inclusion: {in: %w[low normal high urgent]}
end
