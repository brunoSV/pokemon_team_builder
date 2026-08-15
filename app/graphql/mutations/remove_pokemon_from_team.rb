module Mutations
  class RemovePokemonFromTeam < BaseMutation
    argument :slot, Integer, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: false

    def resolve(slot:)
      trainer = context[:current_trainer]
      raise GraphQL::ExecutionError, "Not authorized" unless trainer

      membership = trainer.team_memberships.find_by(slot: slot)
      if membership
        membership.destroy
        { success: true, errors: [] }
      else
        { success: false, errors: [ "Slot #{slot} is already empty" ] }
      end
    end
  end
end
