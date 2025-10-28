require "rails_helper"

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe "associations" do
    it { should belong_to(:organization) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should have_secure_password }
    it { should validate_length_of(:password).is_at_least(6) }

    it "validates email format" do
      user = build(:user, email: "invalid-email")
      expect(user).not_to be_valid
      expect(user.errors[:email]).to be_present
    end
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(user: 0, admin: 1) }
  end

  describe "roles" do
    it "creates a user with default role" do
      user = create(:user)
      expect(user.user?).to be true
    end

    it "creates an admin user" do
      user = create(:user, :admin)
      expect(user.admin?).to be true
    end
  end
end
