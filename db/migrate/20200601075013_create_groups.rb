class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :summary
      t.string :logo_url
      t.string :qrcode_url
      t.string :group_own_wechat
      t.references :app, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
