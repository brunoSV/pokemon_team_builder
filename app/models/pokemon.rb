class Pokemon < ApplicationRecord
  has_many :pokemon_types, -> { order(:slot) }, dependent: :destroy
  has_many :types, through: :pokemon_types

  has_many :pokemon_attacks, -> { order(:slot) }, dependent: :destroy
  has_many :attacks, through: :pokemon_attacks

  has_many :team_memberships, dependent: :destroy

  validates :name, presence: true
  validates :national_dex_number, presence: true, uniqueness: true
  validates :generation, presence: true, inclusion: { in: [ 1, 2 ] }
  validates :image_url, presence: true

  scope :of_type, ->(type_id) { joins(:pokemon_types).where(pokemon_types: { type_id: type_id }) }
  scope :matching_name, ->(name) { where("pokemons.name ILIKE ?", "%#{sanitize_sql_like(name)}%") }
end
