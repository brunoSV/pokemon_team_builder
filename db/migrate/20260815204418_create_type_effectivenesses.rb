class CreateTypeEffectivenesses < ActiveRecord::Migration[8.1]
  def change
    create_table :type_effectivenesses do |t|
      t.references :attacking_type, null: false, foreign_key: { to_table: :types }
      t.references :defending_type, null: false, foreign_key: { to_table: :types }
      t.decimal :multiplier, null: false

      t.timestamps
    end

    add_index :type_effectivenesses, [:attacking_type_id, :defending_type_id], unique: true, name: "index_type_effectivenesses_on_attacker_and_defender"
  end
end
