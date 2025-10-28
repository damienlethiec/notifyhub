require "rails_helper"

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { should belong_to(:from_organization).class_name("Organization") }
    it { should belong_to(:to_organization).class_name("Organization") }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_inclusion_of(:status).in_array(%w[pending sent read]) }
    it { should validate_inclusion_of(:priority).in_array(%w[low normal high urgent]) }
  end

  describe "Active Storage" do
    it "can have an attachment" do
      notification = create(:notification)
      expect(notification.attachment).not_to be_attached
    end
  end

  describe "creation" do
    it "creates a valid notification" do
      notification = build(:notification)
      expect(notification).to be_valid
    end

    it "defaults to pending status" do
      notification = Notification.new(
        from_organization: create(:organization),
        to_organization: create(:organization),
        title: "Test",
        body: "Test body"
      )
      notification.save!
      expect(notification.status).to eq("pending")
    end

    it "defaults to normal priority" do
      notification = Notification.new(
        from_organization: create(:organization),
        to_organization: create(:organization),
        title: "Test",
        body: "Test body"
      )
      notification.save!
      expect(notification.priority).to eq("normal")
    end
  end
end
