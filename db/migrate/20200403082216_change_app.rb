class ChangeApp < ActiveRecord::Migration[6.0]
  def change
    remove_column :apps, :logo, :string
    add_column :apps, :logo_url, :string
    add_column :apps, :summary, :string
  end
end
