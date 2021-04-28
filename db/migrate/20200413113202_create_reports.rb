class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.references :user, foreign_key: true
      t.references :reportable, null: false, polymorphic: true
      t.references :app, null: false
      t.integer :state, default: 0, comment: "0:未处理, 1:已处理"
      t.integer :action, default: 0, comment: "0:未操作, 1:忽略, 2:删除, 3:隐藏"

      t.timestamps
    end
  end
end
