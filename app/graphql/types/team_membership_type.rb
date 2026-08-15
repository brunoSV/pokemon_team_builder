module Types
  class TeamMembershipType < Types::BaseObject
    field :slot, Integer, null: false
    field :pokemon, Types::PokemonType, null: false
  end
end
