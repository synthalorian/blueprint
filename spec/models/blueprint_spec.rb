require "rails_helper"

RSpec.describe Blueprint, type: :model do
  subject { build(:blueprint) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:packages).dependent(:destroy) }
    it { should have_many(:dotfiles).dependent(:destroy) }
    it { should have_many(:environment_variables).dependent(:destroy) }
    it { should have_many(:services).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(120) }
    it { should validate_length_of(:description).is_at_most(500) }

    it "validates presence of yaml_content on update" do
      blueprint = create(:blueprint)
      blueprint.yaml_content = nil
      expect(blueprint).not_to be_valid
      expect(blueprint.errors[:yaml_content]).to include("can't be blank")
    end
  end

  describe "scopes" do
    describe ".publicly" do
      it "returns only public blueprints" do
        public_bp = create(:blueprint, public: true)
        private_bp = create(:blueprint, public: false)

        expect(Blueprint.publicly).to include(public_bp)
        expect(Blueprint.publicly).not_to include(private_bp)
      end
    end

    describe ".recent" do
      it "orders by created_at descending" do
        create(:blueprint, name: "Old", created_at: 2.days.ago)
        create(:blueprint, name: "New", created_at: 1.hour.ago)

        results = Blueprint.recent
        expect(results.first.name).to eq("New")
      end
    end
  end

  describe "#to_shell_script" do
    let(:blueprint) { create(:blueprint, :with_packages) }

    it "generates a valid shell script" do
      script = blueprint.to_shell_script
      expect(script).to start_with("#!/usr/bin/env bash")
      expect(script).to include("set -euo pipefail")
    end

    it "includes package install commands" do
      script = blueprint.to_shell_script
      expect(script).to include("pacman")
    end

    it "escapes environment variable values to prevent shell injection" do
      blueprint.environment_variables.create!(key: "EDITOR", value: "nvim'; rm -rf / #")
      script = blueprint.to_shell_script
      expect(script).not_to include("'; rm -rf / #")
      expect(script).to include("EDITOR=nvim\\'\\;\\ rm\\ -rf\\ /\\ \\#")
    end

    it "encodes dotfile content with base64 to prevent heredoc breakage" do
      blueprint.dotfiles.create!(name: "test", content: "DOTFILE_EOF\nhello", target_path: "/tmp/test")
      script = blueprint.to_shell_script
      expect(script).to include("base64 -d")
      expect(script).not_to include("DOTFILE_EOF")
    end
  end

  describe "#share_url" do
    it "returns a shareable URL" do
      user = create(:user, name: "John Doe")
      blueprint = create(:blueprint, user: user, slug: "test-bp")
      expect(blueprint.share_url("https://blueprint.dev")).to eq("https://blueprint.dev/@john-doe/test-bp")
    end
  end
end
