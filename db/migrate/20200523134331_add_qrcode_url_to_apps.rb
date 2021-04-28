class AddQrcodeUrlToApps < ActiveRecord::Migration[6.0]
  def change
    add_column :apps, :qrcode_url, :string
  end
end
