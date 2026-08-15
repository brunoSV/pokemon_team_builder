class TypeEffectiveness < ApplicationRecord
  belongs_to :attacking_type, class_name: "Type"
  belongs_to :defending_type, class_name: "Type"

  validates :multiplier, presence: true, inclusion: { in: [ 0, 0.5, 1, 2 ] }
  validates :attacking_type_id, uniqueness: { scope: :defending_type_id }
end
