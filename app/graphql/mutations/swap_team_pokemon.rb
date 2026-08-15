module Mutations
  class SwapTeamPokemon < BaseMutation
    argument :pokemon_id, ID, required: true
    argument :slot, Integer, required: true

    field :team_membership, Types::TeamMembershipType, null: true
    field :errors, [ String ], null: false

    def resolve(pokemon_id:, slot:)
      trainer = context[:current_trainer]
      raise GraphQL::ExecutionError, "Not authorized" unless trainer

      membership = trainer.team_memberships.find_by(slot: slot)
      return { team_membership: nil, errors: [ "Slot #{slot} is empty — use addPokemonToTeam to fill it" ] } unless membership

      if membership.update(pokemon_id: pokemon_id)
        { team_membership: membership, errors: [] }
      else
        { team_membership: nil, errors: membership.errors.full_messages }
      end
    end
  end
end
