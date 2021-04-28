json.(@token,:token, :exp)
json.user do
  json.partial! 'user', locals: { user: @user, detail: true }
end