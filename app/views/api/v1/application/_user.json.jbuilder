if user
  # json.cache! ["v1", user, defined?(detail)] do
  json.(user, :id, :nick_name, :avatar_url, :state)
  if defined?(detail)
    if @current_user.present?
      json.following @current_user.find_action(:follow, target: user).blank? ? false : true
    end
    json.(user, :cellphone, :country, :province, :city, :gender, :prefecture, :post_count, :followers_count, :following_count, :actions, :identity, :summary, :wechat,
          :school, :labels, :company, :company_address, :email,
          :toutiao, :wechat_mp, :bilibili, :weibo)
  end
  # end
  json.partial! "abilities", object: user
end
