class ChangeArticle < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :summary, :string, comment: "摘要"
    add_column :articles, :author, :string, comment: "作者"
    add_column :articles, :state, :integer, default: 0, comment: "0:草稿，1:发布"
  end
end
