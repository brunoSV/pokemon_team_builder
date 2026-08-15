class Attack < ApplicationRecord
  has_many :pokemon_attacks, dependent: :destroy
  has_many :pokemons, through: :pokemon_attacks

  validates :name, presence: true, uniqueness: true
end
