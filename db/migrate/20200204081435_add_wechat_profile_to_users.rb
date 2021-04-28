class AddWechatProfileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :country, :string
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :gender, :integer
    add_column :users, :nick_name, :string
    add_column :users, :language, :string
  end
end
