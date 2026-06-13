require "rails_helper"

RSpec.describe "Api::V1::Blueprints", type: :request do
  describe "GET /api/v1/blueprints" do
    let!(:public_blueprint) { create(:blueprint, name: "Public BP", public: true) }
    let!(:private_blueprint) { create(:blueprint, name: "Private BP", public: false) }

    it "returns public blueprints" do
      get api_v1_blueprints_path, headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.map { |b| b["name"] }).to include("Public BP")
      expect(json.map { |b| b["name"] }).not_to include("Private BP")
    end
  end

  describe "GET /api/v1/blueprints/:id" do
    let(:blueprint) { create(:blueprint, :with_packages) }

    it "returns blueprint details" do
      get api_v1_blueprint_path(blueprint)
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq(blueprint.name)
      expect(json["packages"]).to be_an(Array)
    end
  end

  describe "POST /api/v1/blueprints" do
    let(:user) { create(:user) }

    it "creates a blueprint when authenticated" do
      user.update!(authentication_token: SecureRandom.hex(32))
      post api_v1_blueprints_path,
           headers: { "Authorization" => "Bearer #{user.authentication_token}", "Content-Type" => "application/json" },
           params: { blueprint: { name: "API Blueprint", yaml_content: "name: test\n" } }.to_json
      expect(response).to have_http_status(:created)
    end

    it "returns unauthorized without token" do
      post api_v1_blueprints_path,
           headers: { "Content-Type" => "application/json" },
           params: { blueprint: { name: "API Blueprint", yaml_content: "name: test\n" } }.to_json
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/blueprints/:id/download_script" do
    let(:blueprint) { create(:blueprint, :with_packages) }

    it "returns a shell script" do
      get download_script_api_v1_blueprint_path(blueprint)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("shellscript")
    end
  end

  describe "GET /api/v1/blueprints/:id/download_yaml" do
    let(:blueprint) { create(:blueprint) }

    it "returns YAML content" do
      get download_yaml_api_v1_blueprint_path(blueprint)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include("yaml")
    end
  end
end
