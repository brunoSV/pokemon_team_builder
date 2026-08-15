require "rails_helper"

RSpec.describe PokemonType, type: :model do
  let(:pokemon) { Pokemon.create!(name: "Charizard", national_dex_number: 6, generation: 1, image_url: "x") }
  let(:fire) { Type.create!(name: "Fire") }
  let(:flying) { Type.create!(name: "Flying") }

  describe "validations" do
    it "requires slot to be 1 or 2" do
      pokemon_type = PokemonType.new(pokemon: pokemon, type: fire, slot: 3)
      expect(pokemon_type).not_to be_valid
    end

    it "does not allow two types in the same slot for a Pokemon" do
      PokemonType.create!(pokemon: pokemon, type: fire, slot: 1)
      duplicate = PokemonType.new(pokemon: pokemon, type: flying, slot: 1)
      expect(duplicate).not_to be_valid
    end

    it "does not allow the same type twice on one Pokemon" do
      PokemonType.create!(pokemon: pokemon, type: fire, slot: 1)
      duplicate = PokemonType.new(pokemon: pokemon, type: fire, slot: 2)
      expect(duplicate).not_to be_valid
    end
  end
end
