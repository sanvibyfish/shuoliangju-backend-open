if article
  json.(article,:id,:title, :image_url, :likes_count)
  json.created_at (article.created_at.to_f * 1000).to_i
  json.hits article.hits.value
  json.comments_count article.comments.count
  json.user do
    json.partial! "user", user: article.user
  end
  if defined?(detail)
    json.(article,:summary)
    json.content article.content.body
    if @current_user.present?
      json.liked @current_user.find_action(:like, target: article).blank? ? false : true
    end
  end
  json.partial! "abilities", object: article
end