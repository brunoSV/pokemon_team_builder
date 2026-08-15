require "rails_helper"

RSpec.describe PokemonAttack, type: :model do
  let(:pokemon) { Pokemon.create!(name: "Pikachu", national_dex_number: 25, generation: 1, image_url: "x") }
  let(:thunderbolt) { Attack.create!(name: "Thunderbolt") }
  let(:quick_attack) { Attack.create!(name: "Quick Attack") }

  describe "validations" do
    it "requires slot to be between 1 and 4" do
      expect(PokemonAttack.new(pokemon: pokemon, attack: thunderbolt, slot: 5)).not_to be_valid
    end

    it "does not allow two attacks in the same slot for a Pokemon" do
      PokemonAttack.create!(pokemon: pokemon, attack: thunderbolt, slot: 1)
      duplicate = PokemonAttack.new(pokemon: pokemon, attack: quick_attack, slot: 1)
      expect(duplicate).not_to be_valid
    end

    it "does not allow the same attack twice on one Pokemon" do
      PokemonAttack.create!(pokemon: pokemon, attack: thunderbolt, slot: 1)
      duplicate = PokemonAttack.new(pokemon: pokemon, attack: thunderbolt, slot: 2)
      expect(duplicate).not_to be_valid
    end
  end
end
