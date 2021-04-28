if app
  json.(app,:id,:name, :logo_url, :summary,:users_count, :posts_count)
  json.created_at (app.created_at.to_f * 1000).to_i
  json.own do
    json.partial! "user", user: app.own
  end
  json.partial! "abilities", object: app
end