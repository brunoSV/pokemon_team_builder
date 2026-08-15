module Mutations
  class AddPokemonToTeam < BaseMutation
    argument :pokemon_id, ID, required: true
    argument :slot, Integer, required: true

    field :team_membership, Types::TeamMembershipType, null: true
    field :errors, [ String ], null: false

    def resolve(pokemon_id:, slot:)
      trainer = context[:current_trainer]
      raise GraphQL::ExecutionError, "Not authorized" unless trainer

      if trainer.team_memberships.exists?(slot: slot)
        return { team_membership: nil, errors: [ "Slot #{slot} is already occupied — use swapTeamPokemon to replace it" ] }
      end

      membership = trainer.team_memberships.build(pokemon_id: pokemon_id, slot: slot)
      if membership.save
        { team_membership: membership, errors: [] }
      else
        { team_membership: nil, errors: membership.errors.full_messages }
      end
    end
  end
end
