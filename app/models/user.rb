class User < ApplicationRecord
  has_secure_password

  belongs_to :organization

  enum :role, {user: 0, admin: 1}

  validates :email, presence: true, uniqueness: {case_sensitive: false}, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, length: {minimum: 6}, allow_nil: true
end
