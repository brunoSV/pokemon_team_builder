class Type < ApplicationRecord
  has_many :pokemon_types, dependent: :destroy
  has_many :pokemons, through: :pokemon_types

  has_many :attacking_effectivenesses, class_name: "TypeEffectiveness", foreign_key: :attacking_type_id, dependent: :destroy
  has_many :defending_effectivenesses, class_name: "TypeEffectiveness", foreign_key: :defending_type_id, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  # Types this type deals double damage to.
  def strengths
    Type.joins("INNER JOIN type_effectivenesses ON type_effectivenesses.defending_type_id = types.id")
        .where(type_effectivenesses: { attacking_type_id: id, multiplier: 2 })
  end

  # Types this type takes double damage from.
  def weaknesses
    Type.joins("INNER JOIN type_effectivenesses ON type_effectivenesses.attacking_type_id = types.id")
        .where(type_effectivenesses: { defending_type_id: id, multiplier: 2 })
  end
end
