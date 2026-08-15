module Types
  class PokemonPageType < Types::BaseObject
    field :nodes, [ Types::PokemonType ], null: false
    field :page, Integer, null: false
    field :total_pages, Integer, null: false
    field :total_count, Integer, null: false
  end
end
