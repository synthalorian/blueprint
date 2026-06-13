require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
  end

  describe "associations" do
    it { should have_many(:blueprints).dependent(:destroy) }
  end

  describe "#to_slug" do
    it "converts name to URL-safe slug" do
      user = build(:user, name: "John Doe")
      expect(user.to_slug).to eq("john-doe")
    end

    it "handles nil names gracefully" do
      user = build(:user, name: nil)
      expect(user.to_slug).to eq("")
    end
  end
end
