class AddTopAndStatusPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :top, :boolean, comment: "是否置顶", default: false
    remove_column :posts, :status, :integer
    add_column :posts, :state, :integer, comment: "0:正常, -1:隐藏", default: 0
  end
end
