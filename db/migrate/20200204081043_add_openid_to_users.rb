class AddOpenidToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :openid, :string
    add_index  :users, :openid
  end
end
