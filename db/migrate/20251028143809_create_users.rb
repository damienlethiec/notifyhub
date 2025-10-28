class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.references :organization, null: false, foreign_key: true
      t.integer :role, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
