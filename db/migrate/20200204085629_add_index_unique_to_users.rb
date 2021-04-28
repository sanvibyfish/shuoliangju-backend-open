class AddIndexUniqueToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, [:openid, :app_id], unique: true
  end
end
