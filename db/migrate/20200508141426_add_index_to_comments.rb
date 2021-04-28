class AddIndexToComments < ActiveRecord::Migration[6.0]
  def change
    add_index :actions, [:action_type, :target_type, :target_id, :user_id, :user_type], name: "idx_at_tt_ti_ui_ut"
  end
end
