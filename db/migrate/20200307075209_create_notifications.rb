class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :actor, null: false
      t.references :user
      t.string :notify_type, null: false
      t.references :target, polymorphic: true
      t.references :second_target,polymorphic: true
      t.references :third_target,polymorphic: true
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, %i[user_id notify_type]
  end
end
