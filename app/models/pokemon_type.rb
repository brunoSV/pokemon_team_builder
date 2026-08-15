class PokemonType < ApplicationRecord
  belongs_to :pokemon
  belongs_to :type

  validates :slot, presence: true, inclusion: { in: [ 1, 2 ] }
  validates :slot, uniqueness: { scope: :pokemon_id }
  validates :type_id, uniqueness: { scope: :pokemon_id }
end
