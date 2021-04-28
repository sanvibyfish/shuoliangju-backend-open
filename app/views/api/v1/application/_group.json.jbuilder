if group
  json.(group,:id,:name, :logo_url, :summary, :qrcode_url, :group_own_wechat)
  json.created_at (group.created_at.to_f * 1000).to_i
  json.user do
    json.partial! "user", user: group.user
  end
  json.partial! "abilities", object: group
end        