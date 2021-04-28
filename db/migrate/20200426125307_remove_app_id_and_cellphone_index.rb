class RemoveAppIdAndCellphoneIndex < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, [:cellphone]
    add_index :users, :cellphone, unique: true
  end
end
