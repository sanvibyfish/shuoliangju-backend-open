class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :app_id, null: false
      t.integer :status
      t.references :user, null: false, foreign_key: true
      t.text :body
      t.string :video

      t.timestamps
    end
    add_index :posts, [:user_id, :app_id]
  end
end
