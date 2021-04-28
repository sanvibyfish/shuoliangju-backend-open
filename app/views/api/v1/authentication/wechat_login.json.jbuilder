json.(@token,:token, :exp, :openid)
json.user do
  json.partial! 'user', locals: { user: @user, detail: true }
end