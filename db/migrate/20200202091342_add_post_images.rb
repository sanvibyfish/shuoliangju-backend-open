class AddPostImages < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :images_url, :text
  end
end
