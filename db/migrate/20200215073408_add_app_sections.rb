class AddAppSections < ActiveRecord::Migration[6.0]
  def change
    change_table :sections do |t|
      t.references :app, foreign_key: true
    end
  end
end
