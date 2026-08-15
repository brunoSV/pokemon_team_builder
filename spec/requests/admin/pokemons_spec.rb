require "rails_helper"

RSpec.describe "Admin::Pokemons", type: :request do
  let(:admin) { AdminUser.create!(email: "admin@test.com", password: "password") }
  let(:fire) { Type.create!(name: "Fire") }
  let(:flying) { Type.create!(name: "Flying") }
  let(:ember) { Attack.create!(name: "Ember") }
  let(:gust) { Attack.create!(name: "Gust") }

  describe "GET /admin/pokemons" do
    include_examples "requires admin login" do
      let(:make_request) { get admin_pokemons_path }
    end

    it "succeeds when signed in" do
      sign_in admin
      get admin_pokemons_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /admin/pokemons" do
    before { sign_in admin }

    it "creates a Pokemon with its types and attacks" do
      expect {
        post admin_pokemons_path, params: {
          pokemon: {
            name: "Charizard",
            national_dex_number: 6,
            generation: 1,
            image_url: "http://example.com/6.png",
            primary_type_id: fire.id,
            secondary_type_id: flying.id,
            attack_id_1: ember.id,
            attack_id_2: gust.id
          }
        }
      }.to change(Pokemon, :count).by(1)

      pokemon = Pokemon.find_by!(national_dex_number: 6)
      expect(pokemon.types).to contain_exactly(fire, flying)
      expect(pokemon.attacks).to contain_exactly(ember, gust)
      expect(response).to redirect_to(admin_pokemons_path)
    end

    it "rejects invalid params" do
      expect {
        post admin_pokemons_path, params: { pokemon: { name: "", national_dex_number: nil, generation: 1, image_url: "" } }
      }.not_to change(Pokemon, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /admin/pokemons/:id" do
    before { sign_in admin }

    it "updates the Pokemon's types" do
      pokemon = Pokemon.create!(name: "Charmander", national_dex_number: 4, generation: 1, image_url: "x")
      PokemonType.create!(pokemon: pokemon, type: fire, slot: 1)

      patch admin_pokemon_path(pokemon), params: {
        pokemon: { name: "Charmander", national_dex_number: 4, generation: 1, image_url: "x", primary_type_id: flying.id }
      }

      expect(pokemon.reload.types).to contain_exactly(flying)
    end
  end

  describe "DELETE /admin/pokemons/:id" do
    before { sign_in admin }

    it "destroys the Pokemon" do
      pokemon = Pokemon.create!(name: "Charmander", national_dex_number: 4, generation: 1, image_url: "x")
      expect { delete admin_pokemon_path(pokemon) }.to change(Pokemon, :count).by(-1)
    end
  end
end
