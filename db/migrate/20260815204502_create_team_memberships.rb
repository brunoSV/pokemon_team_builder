class CreateTeamMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :team_memberships do |t|
      t.references :trainer, null: false, foreign_key: true
      t.references :pokemon, null: false, foreign_key: true
      t.integer :slot, null: false

      t.timestamps
    end

    add_index :team_memberships, [:trainer_id, :slot], unique: true
    add_index :team_memberships, [:trainer_id, :pokemon_id], unique: true
  end
end
