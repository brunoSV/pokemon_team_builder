Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql"
  end

  post "/graphql", to: "graphql#execute"
  devise_for :admin_users, path: "admin", path_names: { sign_in: "login", sign_out: "logout" },
             skip: [ :registrations, :passwords, :confirmations, :unlocks ],
             controllers: { sessions: "admin/sessions" }
  devise_for :trainers, path: "api/v1/trainers", path_names: { sign_in: "login", sign_out: "logout" },
             skip: [ :passwords, :confirmations, :unlocks ],
             controllers: { sessions: "api/v1/sessions", registrations: "api/v1/registrations" }

  # config.api_only excludes :new/:edit from `resources` by default (API apps
  # don't serve HTML forms) — the admin panel needs them, so list actions explicitly.
  ADMIN_CRUD_ACTIONS = [ :index, :new, :create, :edit, :update, :destroy ]

  namespace :admin do
    root to: "pokemons#index"
    resources :pokemons, only: ADMIN_CRUD_ACTIONS
    resources :types, only: ADMIN_CRUD_ACTIONS
    resources :attacks, only: ADMIN_CRUD_ACTIONS
    resources :type_effectivenesses, only: ADMIN_CRUD_ACTIONS
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
