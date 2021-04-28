class AddIndexToUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, [:cellphone, :app_id], unique: true
  end
end
