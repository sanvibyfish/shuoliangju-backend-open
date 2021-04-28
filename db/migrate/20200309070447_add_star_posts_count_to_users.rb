class AddStarPostsCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :star_posts_count, :integer, default: 0
    add_column :posts, :stars_count, :integer, default: 0
  end
end
