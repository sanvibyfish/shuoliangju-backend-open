class RemoveAccountFormApp < ActiveRecord::Migration[6.0]
  def change
    remove_column :apps, :account_id, :integer
  end
end
