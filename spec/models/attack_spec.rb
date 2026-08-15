require "rails_helper"

RSpec.describe Attack, type: :model do
  describe "validations" do
    it "requires a name" do
      expect(Attack.new(name: nil)).not_to be_valid
    end

    it "requires a unique name" do
      Attack.create!(name: "Tackle")
      expect(Attack.new(name: "Tackle")).not_to be_valid
    end
  end
end
