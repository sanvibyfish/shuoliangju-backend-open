class AddPostAppIndex < ActiveRecord::Migration[6.0]
  def change
    add_index  :posts, :app_id
  end
end
