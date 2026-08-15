# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_15_204502) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
  end

  create_table "attacks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_attacks_on_name", unique: true
  end

  create_table "pokemon_attacks", force: :cascade do |t|
    t.bigint "attack_id", null: false
    t.datetime "created_at", null: false
    t.bigint "pokemon_id", null: false
    t.integer "slot", null: false
    t.datetime "updated_at", null: false
    t.index ["attack_id"], name: "index_pokemon_attacks_on_attack_id"
    t.index ["pokemon_id", "attack_id"], name: "index_pokemon_attacks_on_pokemon_id_and_attack_id", unique: true
    t.index ["pokemon_id", "slot"], name: "index_pokemon_attacks_on_pokemon_id_and_slot", unique: true
    t.index ["pokemon_id"], name: "index_pokemon_attacks_on_pokemon_id"
  end

  create_table "pokemon_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "pokemon_id", null: false
    t.integer "slot", null: false
    t.bigint "type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_id", "slot"], name: "index_pokemon_types_on_pokemon_id_and_slot", unique: true
    t.index ["pokemon_id", "type_id"], name: "index_pokemon_types_on_pokemon_id_and_type_id", unique: true
    t.index ["pokemon_id"], name: "index_pokemon_types_on_pokemon_id"
    t.index ["type_id"], name: "index_pokemon_types_on_type_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "generation", null: false
    t.string "image_url", null: false
    t.string "name", null: false
    t.integer "national_dex_number", null: false
    t.datetime "updated_at", null: false
    t.index ["generation"], name: "index_pokemons_on_generation"
    t.index ["national_dex_number"], name: "index_pokemons_on_national_dex_number", unique: true
  end

  create_table "team_memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "pokemon_id", null: false
    t.integer "slot", null: false
    t.bigint "trainer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["pokemon_id"], name: "index_team_memberships_on_pokemon_id"
    t.index ["trainer_id", "pokemon_id"], name: "index_team_memberships_on_trainer_id_and_pokemon_id", unique: true
    t.index ["trainer_id", "slot"], name: "index_team_memberships_on_trainer_id_and_slot", unique: true
    t.index ["trainer_id"], name: "index_team_memberships_on_trainer_id"
  end

  create_table "trainers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_trainers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_trainers_on_reset_password_token", unique: true
  end

  create_table "type_effectivenesses", force: :cascade do |t|
    t.bigint "attacking_type_id", null: false
    t.datetime "created_at", null: false
    t.bigint "defending_type_id", null: false
    t.decimal "multiplier", null: false
    t.datetime "updated_at", null: false
    t.index ["attacking_type_id", "defending_type_id"], name: "index_type_effectivenesses_on_attacker_and_defender", unique: true
    t.index ["attacking_type_id"], name: "index_type_effectivenesses_on_attacking_type_id"
    t.index ["defending_type_id"], name: "index_type_effectivenesses_on_defending_type_id"
  end

  create_table "types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "pokemon_attacks", "attacks"
  add_foreign_key "pokemon_attacks", "pokemons"
  add_foreign_key "pokemon_types", "pokemons"
  add_foreign_key "pokemon_types", "types"
  add_foreign_key "team_memberships", "pokemons"
  add_foreign_key "team_memberships", "trainers"
  add_foreign_key "type_effectivenesses", "types", column: "attacking_type_id"
  add_foreign_key "type_effectivenesses", "types", column: "defending_type_id"
end
