class CreateAttacks < ActiveRecord::Migration[8.1]
  def change
    create_table :attacks do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :attacks, :name, unique: true
  end
end
