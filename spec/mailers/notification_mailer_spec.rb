require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "new_notification" do
    let(:organization) { create(:organization, name: "Test Org") }
    let(:user) { create(:user, email: "test@example.com", organization: organization) }
    let(:from_org) { create(:organization, name: "From Org") }
    let(:notification) { create(:notification, title: "Test Notification", from_organization: from_org, to_organization: organization) }
    let(:mail) { NotificationMailer.new_notification(user, notification) }

    it "renders the headers" do
      expect(mail.subject).to eq("Nouvelle notification : Test Notification")
      expect(mail.to).to eq(["test@example.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Bonjour test@example.com")
      expect(mail.body.encoded).to match("Test Notification")
      expect(mail.body.encoded).to match("From Org")
    end
  end
end
