class CreateApps < ActiveRecord::Migration[6.0]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :logo
      t.string :app_key
      t.integer :status
      t.integer :auto_updated

      t.timestamps
    end

    change_table :users do |t|
      t.belongs_to :app
    end
  end
end
