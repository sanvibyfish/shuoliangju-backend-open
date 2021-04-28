class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :img_url
      t.text :body
      t.bigint :price
      t.references :user, foreign_key: true
      t.timestamps

    end
  end
end
