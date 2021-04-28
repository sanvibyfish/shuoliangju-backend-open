class RenameImageUrlToProduct < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :img_url, :string
    add_column :products, :images_url, :text
  end
end
