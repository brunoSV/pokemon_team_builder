require "rails_helper"

RSpec.describe TypeEffectiveness, type: :model do
  let(:fire) { Type.create!(name: "Fire") }
  let(:grass) { Type.create!(name: "Grass") }

  describe "validations" do
    it "requires a multiplier of 0, 0.5, 1, or 2" do
      valid = TypeEffectiveness.new(attacking_type: fire, defending_type: grass, multiplier: 3)
      expect(valid).not_to be_valid
      expect(valid.errors[:multiplier]).to be_present
    end

    it "requires a unique attacking/defending type pair" do
      TypeEffectiveness.create!(attacking_type: fire, defending_type: grass, multiplier: 2)
      duplicate = TypeEffectiveness.new(attacking_type: fire, defending_type: grass, multiplier: 0.5)
      expect(duplicate).not_to be_valid
    end

    it "allows the same types in the reverse order" do
      TypeEffectiveness.create!(attacking_type: fire, defending_type: grass, multiplier: 2)
      reverse = TypeEffectiveness.new(attacking_type: grass, defending_type: fire, multiplier: 0.5)
      expect(reverse).to be_valid
    end
  end
end
