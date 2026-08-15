# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [ Types::NodeType, null: true ], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ ID ], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :pokemons, Types::PokemonPageType, null: false do
      argument :page, Integer, required: false
      argument :type_id, ID, required: false
    end

    def pokemons(page: 1, type_id: nil)
      scope = Pokemon.includes(:types, :attacks).order(:national_dex_number)
      scope = scope.of_type(type_id) if type_id.present?

      pagy = Pagy.new(count: scope.count, page: page || 1, limit: 20)
      {
        nodes: scope.offset(pagy.offset).limit(pagy.limit),
        page: pagy.page,
        total_pages: pagy.pages,
        total_count: pagy.count
      }
    end

    field :pokemon, Types::PokemonType, null: true do
      argument :id, ID, required: true
    end

    def pokemon(id:)
      Pokemon.find_by(id: id)
    end

    field :types, [ Types::TypeType ], null: false

    def types
      Type.order(:name)
    end

    field :my_team, [ Types::TeamMembershipType ], null: false

    def my_team
      trainer = context[:current_trainer]
      raise GraphQL::ExecutionError, "Not authorized" unless trainer

      trainer.team_memberships.includes(pokemon: [ :types, :attacks ]).order(:slot)
    end
  end
end
