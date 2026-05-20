require "rails_helper"

RSpec.describe "Api::V1::Blueprints", type: :request do
  describe "GET /api/v1/blueprints" do
    let!(:public_blueprint) { create(:blueprint, name: "Public BP", public: true) }
    let!(:private_blueprint) { create(:blueprint, name: "Private BP", public: false) }

    it "returns public blueprints" do
      get api_v1_blueprints_path, headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:ok)
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
