class AddAccountIdToApps < ActiveRecord::Migration[6.0]
  def change
    add_reference :apps, :account, foreign_key: true
  end
end
