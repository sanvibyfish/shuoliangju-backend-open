class AddSummarySections < ActiveRecord::Migration[6.0]
  def change
    add_column :sections, :summary, :string
  end
end
