class AddWechatInfoToapps < ActiveRecord::Migration[6.0]
  def change
    add_column :apps, :wechat_app_id, :string, comment: "微信app_id"
    add_column :apps, :wechat_app_secret, :string, comment: "微信app_secret"
  end
end
