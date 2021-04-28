class AddQrcodeUrlToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :qrcode_url, :string
  end
end
