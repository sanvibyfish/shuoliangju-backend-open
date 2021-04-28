class AddOwnToApps < ActiveRecord::Migration[6.0]
  def change
    add_column :apps, :own_id, :integer, comment: "创建用户"
    add_index :apps, :own_id
  end
end
