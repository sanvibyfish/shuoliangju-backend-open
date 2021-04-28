class ChangeUserAvatarToAvatarUrl < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :avatar, :avatar_url
  end
end
