# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :add_pokemon_to_team, mutation: Mutations::AddPokemonToTeam
    field :swap_team_pokemon, mutation: Mutations::SwapTeamPokemon
    field :remove_pokemon_from_team, mutation: Mutations::RemovePokemonFromTeam
  end
end
