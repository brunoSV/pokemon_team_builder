class CreatePokemonAttacks < ActiveRecord::Migration[8.1]
  def change
    create_table :pokemon_attacks do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :attack, null: false, foreign_key: true
      t.integer :slot, null: false

      t.timestamps
    end

    add_index :pokemon_attacks, [:pokemon_id, :slot], unique: true
    add_index :pokemon_attacks, [:pokemon_id, :attack_id], unique: true
  end
end
