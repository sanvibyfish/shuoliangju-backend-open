class AddParentToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :parent, foreign_key: { to_table: :comments }
  end
end
