class CreatePokemons < ActiveRecord::Migration[8.1]
  def change
    create_table :pokemons do |t|
      t.string :name, null: false
      t.integer :national_dex_number, null: false
      t.integer :generation, null: false
      t.string :image_url, null: false

      t.timestamps
    end

    add_index :pokemons, :national_dex_number, unique: true
    add_index :pokemons, :generation
  end
end
