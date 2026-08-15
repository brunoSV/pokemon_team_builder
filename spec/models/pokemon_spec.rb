require "rails_helper"

RSpec.describe Pokemon, type: :model do
  describe "validations" do
    it "requires a name, national_dex_number, generation, and image_url" do
      pokemon = Pokemon.new
      expect(pokemon).not_to be_valid
      expect(pokemon.errors[:name]).to be_present
      expect(pokemon.errors[:national_dex_number]).to be_present
      expect(pokemon.errors[:generation]).to be_present
      expect(pokemon.errors[:image_url]).to be_present
    end

    it "requires generation to be 1 or 2" do
      pokemon = Pokemon.new(name: "Test", national_dex_number: 1, generation: 3, image_url: "http://example.com/x.png")
      expect(pokemon).not_to be_valid
      expect(pokemon.errors[:generation]).to be_present
    end

    it "requires a unique national_dex_number" do
      Pokemon.create!(name: "Bulbasaur", national_dex_number: 1, generation: 1, image_url: "http://example.com/1.png")
      duplicate = Pokemon.new(name: "Other", national_dex_number: 1, generation: 1, image_url: "http://example.com/2.png")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:national_dex_number]).to include("has already been taken")
    end
  end

  describe ".of_type" do
    it "returns only Pokemon that have the given type" do
      fire = Type.create!(name: "Fire")
      water = Type.create!(name: "Water")
      charmander = Pokemon.create!(name: "Charmander", national_dex_number: 4, generation: 1, image_url: "x")
      squirtle = Pokemon.create!(name: "Squirtle", national_dex_number: 7, generation: 1, image_url: "x")
      PokemonType.create!(pokemon: charmander, type: fire, slot: 1)
      PokemonType.create!(pokemon: squirtle, type: water, slot: 1)

      expect(Pokemon.of_type(fire.id)).to contain_exactly(charmander)
    end
  end
end
