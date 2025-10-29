class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :siret, null: false

      t.timestamps
    end

    add_index :organizations, :siret, unique: true
  end
end
