class AddCreatedAtToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :deleted_at, :datetime
    add_column :posts, :who_deleted, :string
    add_column :posts, :grade, :integer, default: 0
    add_index  :posts, :deleted_at
  end
end
