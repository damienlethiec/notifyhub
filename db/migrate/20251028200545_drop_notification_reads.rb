class DropNotificationReads < ActiveRecord::Migration[8.1]
  def change
    drop_table :notification_reads do |t|
      t.references :notification, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :read_at, null: false

      t.timestamps

      t.index [:notification_id, :user_id], unique: true
    end

    drop_table :notification_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :email_enabled, default: true
      t.boolean :high_priority_only, default: false
      t.jsonb :delivery_hours, default: {}

      t.timestamps
    end
  end
end
