class AddJtiToTrainers < ActiveRecord::Migration[8.1]
  def change
    add_column :trainers, :jti, :string, null: false, default: ""
    add_index :trainers, :jti, unique: true

    # JWT auth replaces cookie-based sessions; drop the now-unused Devise modules' columns.
    remove_column :trainers, :reset_password_token, :string
    remove_column :trainers, :reset_password_sent_at, :datetime
    remove_column :trainers, :remember_created_at, :datetime
  end
end
