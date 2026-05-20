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
    it { should validate_presence_of(:yaml_content) }
    it { should validate_length_of(:description).is_at_most(500) }
  end

  describe "scopes" do
    describe ".publicly" do
      it "returns only public blueprints" do
        public_bp = create(:blueprint, public: true)
        _private_bp = create(:blueprint, public: false)

        expect(Blueprint.publicly).to include(public_bp)
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
  end
end
