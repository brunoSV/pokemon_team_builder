require "rails_helper"

RSpec.describe TeamMembership, type: :model do
  let(:trainer) { Trainer.create!(email: "ash@test.com", password: "password", name: "Ash") }
  let(:pikachu) { Pokemon.create!(name: "Pikachu", national_dex_number: 25, generation: 1, image_url: "x") }
  let(:eevee) { Pokemon.create!(name: "Eevee", national_dex_number: 133, generation: 1, image_url: "x") }

  describe "validations" do
    it "requires slot to be between 1 and 6" do
      expect(TeamMembership.new(trainer: trainer, pokemon: pikachu, slot: 7)).not_to be_valid
    end

    it "does not allow two Pokemon in the same slot for a trainer" do
      TeamMembership.create!(trainer: trainer, pokemon: pikachu, slot: 1)
      duplicate = TeamMembership.new(trainer: trainer, pokemon: eevee, slot: 1)
      expect(duplicate).not_to be_valid
    end

    it "does not allow the same Pokemon twice on one trainer's team" do
      TeamMembership.create!(trainer: trainer, pokemon: pikachu, slot: 1)
      duplicate = TeamMembership.new(trainer: trainer, pokemon: pikachu, slot: 2)
      expect(duplicate).not_to be_valid
    end
  end
end
