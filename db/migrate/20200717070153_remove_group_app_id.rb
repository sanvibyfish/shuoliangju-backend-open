class RemoveGroupAppId < ActiveRecord::Migration[6.0]
  def change
    remove_column :groups, :app_id, :integer
  end
end
