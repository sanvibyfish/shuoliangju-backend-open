class RemoveAppToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, [:openid, :app_id]
    remove_column :users, :app_id, :integer

  end
end
