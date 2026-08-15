class TeamMembership < ApplicationRecord
  belongs_to :trainer
  belongs_to :pokemon

  validates :slot, presence: true, inclusion: { in: 1..6 }
  validates :slot, uniqueness: { scope: :trainer_id }
  validates :pokemon_id, uniqueness: { scope: :trainer_id }
end
