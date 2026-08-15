module Types
  class PokemonType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :national_dex_number, Integer, null: false
    field :generation, Integer, null: false
    field :image_url, String, null: false
    field :types, [ Types::TypeType ], null: false
    field :attacks, [ Types::AttackType ], null: false
  end
end
