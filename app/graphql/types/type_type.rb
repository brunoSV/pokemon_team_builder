module Types
  class TypeType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :strengths, [ Types::TypeType ], null: false
    field :weaknesses, [ Types::TypeType ], null: false

    def strengths
      object.strengths
    end

    def weaknesses
      object.weaknesses
    end
  end
end
