class PokemonAttack < ApplicationRecord
  belongs_to :pokemon
  belongs_to :attack

  validates :slot, presence: true, inclusion: { in: 1..4 }
  validates :slot, uniqueness: { scope: :pokemon_id }
  validates :attack_id, uniqueness: { scope: :pokemon_id }
end
