class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.string :name
      t.string :icon_url
      t.integer  :sort, default: 0, null: false

      t.timestamps
    end

    change_table :posts do |t|
      t.belongs_to :section
    end
  end
end
