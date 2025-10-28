class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :from_organization, null: false, foreign_key: {to_table: :organizations}
      t.references :to_organization, null: false, foreign_key: {to_table: :organizations}
      t.string :title, null: false
      t.text :body, null: false
      t.string :status, default: "pending"
      t.string :priority, default: "normal"

      t.timestamps
    end

    # Index pour performance (mais manque includes dans code = BUG)
    add_index :notifications, [:to_organization_id, :created_at]
    add_index :notifications, [:from_organization_id, :created_at]
  end
end
