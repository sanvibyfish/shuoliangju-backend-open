class AddAppToArticle < ActiveRecord::Migration[6.0]
  def change
    change_table :articles do |t|
      t.references :app, foreign_key: true
    end
    remove_column :articles, :body, :string
  end
end
