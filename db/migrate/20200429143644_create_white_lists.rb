class CreateWhiteLists < ActiveRecord::Migration[6.0]
  def change
    create_table :white_lists do |t|
      t.references :white_listable, polymorphic: true, null: false
      t.string :action

      t.timestamps
    end
    add_index :white_lists, :action
    add_index :white_lists, [:action, :white_listable_type, :white_listable_id], name: "idx_action_and_able_id"
  end
end
