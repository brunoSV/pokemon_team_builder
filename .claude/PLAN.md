# Pokemon Team Builder

**Product description (verbatim from user request):**
Pokemon Team Builder app for the first and second generation. Pokemon have types, a picture, and 4 attacks (originally said "abilities", clarified to mean attacks/moves). Each type has strengths and weaknesses against other types. Trainers can be added; a trainer has a team of 6 Pokemon chosen from all available Pokemon, and can switch team members by swapping between Pokemon. Trainers can browse all Pokemon with pagination, filter by type, and view their full team on a separate page.

Backend: Ruby on Rails. API: GraphQL. Frontend: React with TypeScript.

**One-liner:** A Pokemon Team Builder for Gen 1 & 2 — trainers log in, browse the Pokedex (paginated, filterable by type), and build/manage a 6-Pokemon team by swapping members in and out.

**Slug:** `pokemon_team_builder` (backend) / `pokemon_team_builder-frontend` (frontend)

## Entities

| Model | Purpose |
|---|---|
| `Type` | The 17 Gen 1+2 types (Dark/Steel included, Fairy excluded — that's Gen 6) |
| `TypeEffectiveness` | Self-join: `attacking_type`, `defending_type`, `multiplier` (0 / 0.5 / 1 / 2) — drives strengths/weaknesses |
| `Pokemon` | `name`, `national_dex_number`, `generation`, `image_url` (plain URL string, e.g. PokeAPI sprite CDN) |
| `PokemonType` | Join table — up to 2 types per Pokemon, ordered (primary/secondary) |
| `Attack` | `name` — a move a Pokemon can know |
| `PokemonAttack` | Join table — up to 4 attacks per Pokemon, slotted 1–4 |
| `Trainer` | End user, Devise login, self-service signup |
| `TeamMembership` | `trainer`, `pokemon`, `slot` (1–6) — one Pokemon per slot, unique per trainer; swapping = replacing the pokemon in a slot |
| `AdminUser` | Console-created only (no self-registration), manages Pokemon/Type/Attack data via plain Rails views |

**Seed data:** Full Gen 1 & 2 Pokemon/Type/Attack/TypeEffectiveness data, plus one default trainer: `trainer@test.com` / `okokok`.

## Auth

- **Trainer** — `devise-jwt`: signup/login/logout as thin REST endpoints (`/api/v1/registrations`, `/api/v1/login`, `/api/v1/logout`); everything else (Pokedex, team management) goes through GraphQL, with `context[:current_trainer]` set from the JWT-authenticated session.
- **AdminUser** — session-based Devise under `/admin`, console/seed-created only, no self-signup.

## Stack

- Rails 8 **API-only** (`--api`) backend, with session/cookie middleware added back just for the `/admin` namespace so it can run plain server-rendered views alongside the token-based API.
- **GraphQL** (graphql-ruby) mounted at `/api/graphql`, GraphiQL in dev.
- **React + TypeScript** SPA (Vite + Apollo Client), scaffolded by this skill, calling GraphQL for data and the small REST auth endpoints for login/signup.
- Gems: `devise`, `devise-jwt`, `graphql`, `graphiql-rails` (dev), `rack-cors`, `pagy` (pagination).

## GraphQL surface

- **Queries:** `pokemons(page, typeId)` (paginated + filterable), `pokemon(id)`, `types` (with computed `strengths`/`weaknesses`), `myTeam`
- **Mutations:** `addPokemonToTeam(pokemonId, slot)`, `removePokemonFromTeam(slot)`, `swapTeamPokemon(slot, pokemonId)`

## Frontend pages

- Login / Signup
- **Pokedex** — paginated Pokemon grid, filter by type, "add/swap into team" action
- **Team** — read-only display of the trainer's full 6-Pokemon roster, separate page

## Not doing

- No background jobs (nothing async needed)
- No file uploads (images are URLs)
- No admin UI in React (plain Rails views only)

## Build order

- **Checkpoint A** — Data model: `Type`, `TypeEffectiveness`, `Pokemon`, `PokemonType`, `Attack`, `PokemonAttack`, `Trainer` (devise), `TeamMembership`, `AdminUser` (devise, console-only). Admin routes/controllers/views (plain Rails, session-based) for Pokemon/Type/Attack/TypeEffectiveness CRUD.
- **Checkpoint B** — GraphQL layer (queries/mutations above), devise-jwt wiring for Trainer, rack-cors config, seed script (Gen 1&2 data + default trainer).
- **Checkpoint C** — React + TypeScript SPA: Apollo Client, Login/Signup, Pokedex (paginated + filter), Team page.
- **Checkpoint D** — Tests: RSpec (model specs, admin request specs, GraphQL request specs) + Vitest/RTL on the frontend.

Stop and review after each checkpoint before committing.
