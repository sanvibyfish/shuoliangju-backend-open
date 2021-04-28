class AddCountryCodeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :country_code,:string
  end
end
