class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.integer :likes_count, default: 0
      t.string :image_url
      t.references :user
      t.timestamps
    end
  end
end
