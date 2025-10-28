require "rails_helper"

RSpec.describe Organization, type: :model do
  describe "associations" do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:sent_notifications).class_name("Notification").with_foreign_key("from_organization_id").dependent(:destroy) }
    it { should have_many(:received_notifications).class_name("Notification").with_foreign_key("to_organization_id").dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:siret) }
    it { should validate_length_of(:siret).is_equal_to(14) }

    it "validates uniqueness of siret" do
      create(:organization, siret: "12345678901234")
      duplicate = build(:organization, siret: "12345678901234")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:siret]).to include("has already been taken")
    end
  end

  describe "creation" do
    it "creates a valid organization" do
      org = build(:organization)
      expect(org).to be_valid
    end
  end
end
