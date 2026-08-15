class Trainer < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :team_memberships, -> { order(:slot) }, dependent: :destroy
  has_many :pokemons, through: :team_memberships
end
