require "rails_helper"

RSpec.describe "BlueprintsController", type: :request do
  describe "POST /blueprints/:id/duplicate" do
    let(:user) { create(:user) }
    let(:blueprint) { create(:blueprint, user: user) }

    before do
      sign_in user
    end

    it "duplicates a blueprint with its associations" do
      blueprint.packages.create!(name: "neovim", category: "pacman")
      blueprint.dotfiles.create!(name: "vimrc", content: "set number", target_path: "/home/user/.vimrc")
      blueprint.environment_variables.create!(key: "EDITOR", value: "nvim")
      blueprint.services.create!(name: "docker", enabled: true)

      expect {
        post duplicate_blueprint_path(blueprint)
      }.to change(Blueprint, :count).by(1)

      dup = Blueprint.last
      expect(dup.name).to eq("#{blueprint.name} (copy)")
      expect(dup.packages.count).to eq(1)
      expect(dup.dotfiles.count).to eq(1)
      expect(dup.environment_variables.count).to eq(1)
      expect(dup.services.count).to eq(1)
      expect(response).to redirect_to(edit_blueprint_path(dup))
    end
  end

  describe "GET /blueprints" do
    it "lists public blueprints" do
      create(:blueprint, public: true)
      get blueprints_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /blueprints/:id" do
    let(:blueprint) { create(:blueprint, public: true) }

    it "shows a public blueprint" do
      get blueprint_path(blueprint)
      expect(response).to have_http_status(:ok)
    end
  end
end
