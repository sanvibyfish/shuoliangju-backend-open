class ChangeGroupColumn < ActiveRecord::Migration[6.0]
  def change
    change_column :groups, :summary, :text
  end
end
