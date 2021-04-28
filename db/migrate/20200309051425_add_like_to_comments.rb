class AddLikeToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :likes_count, :integer, default: 0
  end
end
