require "rails_helper"

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /api/v1/login" do
    let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

    it "returns a token with valid credentials" do
      post api_v1_login_path, params: { email: user.email, password: "password123" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["token"]).to be_present
      expect(json["email"]).to eq(user.email)
      expect(user.reload.authentication_token).to be_present
    end

    it "returns unauthorized with invalid credentials" do
      post api_v1_login_path, params: { email: user.email, password: "wrongpassword" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/logout" do
    let(:user) { create(:user, authentication_token: SecureRandom.hex(32)) }

    it "clears the authentication token" do
      delete api_v1_logout_path, headers: { "Authorization" => "Bearer #{user.authentication_token}" }
      expect(response).to have_http_status(:no_content)
      expect(user.reload.authentication_token).to be_nil
    end
  end
end
