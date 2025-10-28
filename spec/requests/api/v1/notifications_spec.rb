require "rails_helper"

RSpec.describe "Api::V1::Notifications", type: :request do
  let(:org_a) { create(:organization) }
  let(:org_b) { create(:organization) }
  let(:admin_user) { create(:user, :admin, organization: org_a) }
  let(:regular_user) { create(:user, organization: org_b) }
  let(:token) { JsonWebToken.encode(user_id: admin_user.id) }
  let(:headers) { {"Authorization" => "Bearer #{token}", "Content-Type" => "application/json"} }

  describe "GET /api/v1/notifications" do
    before do
      create_list(:notification, 3, from_organization: org_a, to_organization: org_b)
    end

    context "when authenticated" do
      let(:user_token) { JsonWebToken.encode(user_id: regular_user.id) }
      let(:user_headers) { {"Authorization" => "Bearer #{user_token}"} }

      it "returns notifications for user's organization" do
        # Désactiver Bullet.raise pour ce test qui contient volontairement un N+1
        Bullet.raise = false if defined?(Bullet)

        get "/api/v1/notifications", headers: user_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(3)

        # Réactiver Bullet.raise
        Bullet.raise = true if defined?(Bullet)
      end
    end

    context "when not authenticated" do
      it "returns 401 unauthorized" do
        get "/api/v1/notifications"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/notifications/:id" do
    let(:notification) { create(:notification, from_organization: org_a, to_organization: org_b) }

    context "when notification belongs to another organization" do
      # Ce test DEVRAIT échouer à cause du bug d'authorization
      # Le candidat doit identifier et corriger ce problème pendant l'entretien
      it "returns 403 Forbidden (BUG: actuellement retourne 200)" do
        get "/api/v1/notifications/#{notification.id}", headers: headers

        # Ce test va PASSER mais il ne devrait pas
        # C'est le BUG à identifier : pas d'authorization
        expect(response).to have_http_status(:ok)

        # Le comportement ATTENDU serait :
        # expect(response).to have_http_status(:forbidden)
      end
    end

    context "when notification belongs to user's organization" do
      let(:user_token) { JsonWebToken.encode(user_id: regular_user.id) }
      let(:user_headers) { {"Authorization" => "Bearer #{user_token}"} }

      it "returns the notification" do
        get "/api/v1/notifications/#{notification.id}", headers: user_headers
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json["id"]).to eq(notification.id)
      end
    end
  end

  describe "POST /api/v1/notifications" do
    let(:valid_params) do
      {
        notification: {
          title: "Test Notification",
          body: "Test body",
          to_organization_id: org_b.id,
          from_organization_id: org_a.id,
          priority: "high"
        }
      }
    end

    context "when authenticated as admin" do
      it "creates a notification" do
        expect {
          post "/api/v1/notifications", params: valid_params.to_json, headers: headers
        }.to change(Notification, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "when authenticated as regular user" do
      let(:user_token) { JsonWebToken.encode(user_id: regular_user.id) }
      let(:user_headers) { {"Authorization" => "Bearer #{user_token}", "Content-Type" => "application/json"} }

      # Ce test DEVRAIT échouer car seuls les admins devraient pouvoir créer
      # Mais à cause du bug dans la policy, ça passe
      it "creates a notification (BUG: ne devrait pas pouvoir)" do
        expect {
          post "/api/v1/notifications", params: valid_params.to_json, headers: user_headers
        }.to change(Notification, :count).by(1)

        # Le comportement ATTENDU serait :
        # expect(response).to have_http_status(:forbidden)
      end
    end
  end

end
