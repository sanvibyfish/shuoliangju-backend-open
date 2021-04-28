class AddReplyToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :reply_to, foreign_key: { to_table: :comments }
  end
end
