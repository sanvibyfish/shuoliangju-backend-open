class AddPrefectureToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :prefecture, :string
  end
end
