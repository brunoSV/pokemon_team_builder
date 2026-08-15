require "rails_helper"

RSpec.describe Type, type: :model do
  describe "validations" do
    it "requires a name" do
      type = Type.new(name: nil)
      expect(type).not_to be_valid
      expect(type.errors[:name]).to include("can't be blank")
    end

    it "requires a unique name" do
      Type.create!(name: "Fire")
      duplicate = Type.new(name: "Fire")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
    end
  end

  describe "#strengths and #weaknesses" do
    it "returns the types this type is super effective against and weak to" do
      fire = Type.create!(name: "Fire")
      grass = Type.create!(name: "Grass")
      water = Type.create!(name: "Water")

      TypeEffectiveness.create!(attacking_type: fire, defending_type: grass, multiplier: 2)
      TypeEffectiveness.create!(attacking_type: water, defending_type: fire, multiplier: 2)

      expect(fire.strengths).to contain_exactly(grass)
      expect(fire.weaknesses).to contain_exactly(water)
    end
  end
end
