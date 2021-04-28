class AddProfileToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :identity, :string, comment: "身份介绍"
    add_column :users, :summary, :string, comment: "简介"
    add_column :users, :wechat, :string, comment: "微信号"
    add_column :users, :school, :string, comment: "学校"
    add_column :users, :labels, :string, comment: "标签"
    add_column :users, :company, :string, comment: "公司"
    add_column :users, :company_address, :string, comment: "公司地址"
    add_column :users, :email, :string, comment: "邮箱"
    add_column :users, :toutiao, :string, comment: "头条号"
    add_column :users, :wechat_mp, :string, comment: "公众号"
    add_column :users, :bilibili, :string, comment: "bilibili"
    add_column :users, :weibo, :string, comment: "微博"
  end
end
