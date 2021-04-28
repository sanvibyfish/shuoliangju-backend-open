class AddRoleToSections < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :role, :integer, comment: "0:正常, 1:管理员", default: 0
  end
end
