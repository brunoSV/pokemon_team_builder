class CreatePokemonTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :pokemon_types do |t|
      t.references :pokemon, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.integer :slot, null: false

      t.timestamps
    end

    add_index :pokemon_types, [:pokemon_id, :slot], unique: true
    add_index :pokemon_types, [:pokemon_id, :type_id], unique: true
  end
end
