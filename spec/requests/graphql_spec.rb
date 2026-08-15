require "rails_helper"

RSpec.describe "GraphQL", type: :request do
  let(:fire) { Type.create!(name: "Fire") }
  let(:water) { Type.create!(name: "Water") }
  let!(:charmander) { Pokemon.create!(name: "Charmander", national_dex_number: 4, generation: 1, image_url: "x").tap { |p| PokemonType.create!(pokemon: p, type: fire, slot: 1) } }
  let!(:squirtle) { Pokemon.create!(name: "Squirtle", national_dex_number: 7, generation: 1, image_url: "x").tap { |p| PokemonType.create!(pokemon: p, type: water, slot: 1) } }
  let(:trainer) { Trainer.create!(email: "ash@test.com", password: "password", name: "Ash") }

  def post_graphql(query, variables: {})
    post "/graphql", params: { query: query, variables: variables.to_json }
    JSON.parse(response.body)
  end

  describe "pokemons query" do
    it "paginates and filters by type" do
      result = post_graphql(<<~GQL, variables: { typeId: fire.id.to_s })
        query($typeId: ID) {
          pokemons(typeId: $typeId) { totalCount nodes { name } }
        }
      GQL

      expect(result["data"]["pokemons"]["totalCount"]).to eq(1)
      expect(result["data"]["pokemons"]["nodes"].first["name"]).to eq("Charmander")
    end

    it "filters by name, case-insensitively" do
      result = post_graphql(<<~GQL, variables: { name: "char" })
        query($name: String) {
          pokemons(name: $name) { totalCount nodes { name } }
        }
      GQL

      expect(result["data"]["pokemons"]["totalCount"]).to eq(1)
      expect(result["data"]["pokemons"]["nodes"].first["name"]).to eq("Charmander")
    end
  end

  describe "types query" do
    it "returns computed strengths and weaknesses" do
      TypeEffectiveness.create!(attacking_type: water, defending_type: fire, multiplier: 2)

      result = post_graphql(<<~GQL)
        query {
          types { name weaknesses { name } }
        }
      GQL

      fire_type = result["data"]["types"].find { |t| t["name"] == "Fire" }
      expect(fire_type["weaknesses"].map { |t| t["name"] }).to contain_exactly("Water")
    end
  end

  describe "myTeam query" do
    it "requires authentication" do
      result = post_graphql("{ myTeam { slot } }")
      expect(result["errors"].first["message"]).to eq("Not authorized")
    end

    it "returns the signed-in trainer's team" do
      sign_in trainer
      TeamMembership.create!(trainer: trainer, pokemon: charmander, slot: 1)

      result = post_graphql("{ myTeam { slot pokemon { name } } }")

      expect(result["data"]["myTeam"]).to eq([ { "slot" => 1, "pokemon" => { "name" => "Charmander" } } ])
    end
  end

  describe "addPokemonToTeam mutation" do
    it "adds a Pokemon to an empty slot" do
      sign_in trainer

      result = post_graphql(<<~GQL, variables: { pokemonId: charmander.id.to_s, slot: 1 })
        mutation($pokemonId: ID!, $slot: Int!) {
          addPokemonToTeam(input: { pokemonId: $pokemonId, slot: $slot }) {
            teamMembership { slot pokemon { name } }
            errors
          }
        }
      GQL

      expect(result["data"]["addPokemonToTeam"]["errors"]).to eq([])
      expect(TeamMembership.find_by(trainer: trainer, slot: 1).pokemon).to eq(charmander)
    end

    it "rejects an already-occupied slot" do
      sign_in trainer
      TeamMembership.create!(trainer: trainer, pokemon: charmander, slot: 1)

      result = post_graphql(<<~GQL, variables: { pokemonId: squirtle.id.to_s, slot: 1 })
        mutation($pokemonId: ID!, $slot: Int!) {
          addPokemonToTeam(input: { pokemonId: $pokemonId, slot: $slot }) { errors }
        }
      GQL

      expect(result["data"]["addPokemonToTeam"]["errors"]).not_to be_empty
    end
  end

  describe "swapTeamPokemon mutation" do
    it "replaces the Pokemon in an occupied slot" do
      sign_in trainer
      TeamMembership.create!(trainer: trainer, pokemon: charmander, slot: 1)

      result = post_graphql(<<~GQL, variables: { pokemonId: squirtle.id.to_s, slot: 1 })
        mutation($pokemonId: ID!, $slot: Int!) {
          swapTeamPokemon(input: { pokemonId: $pokemonId, slot: $slot }) { errors }
        }
      GQL

      expect(result["data"]["swapTeamPokemon"]["errors"]).to eq([])
      expect(TeamMembership.find_by(trainer: trainer, slot: 1).pokemon).to eq(squirtle)
    end
  end

  describe "removePokemonFromTeam mutation" do
    it "removes the Pokemon from the slot" do
      sign_in trainer
      TeamMembership.create!(trainer: trainer, pokemon: charmander, slot: 1)

      result = post_graphql(<<~GQL, variables: { slot: 1 })
        mutation($slot: Int!) {
          removePokemonFromTeam(input: { slot: $slot }) { success errors }
        }
      GQL

      expect(result["data"]["removePokemonFromTeam"]["success"]).to eq(true)
      expect(TeamMembership.find_by(trainer: trainer, slot: 1)).to be_nil
    end
  end
end
