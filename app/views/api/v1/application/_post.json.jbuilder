if post
  json.(post, :id, :body, :grade,:top,:state, :app_id)

  if post.images_url
    json.images_url JSON.parse(post.images_url)
    json.thumbnails_url JSON.parse(post.images_url).map { |url|
      "#{url}?x-oss-process=image/resize,h_180,w_120"
    }
  end
  json.app do
    json.partial! "app", app: post.app
  end
  json.app_name post.app.name
  json.app_logo_url post.app.logo_url
  json.created_at (post.created_at.to_f * 1000).to_i
  json.likes_count post.likes_count
  json.stars_count post.stars_count
  if  @current_user.present?
    json.liked @current_user.find_action(:like, target: post).blank? ? false : true
  end

  if defined?(detail)
    if @current_user.present?
      json.star @current_user.find_action(:star, target: post).blank? ? false : true
    end
  end


  json.user do
    json.partial! "user", user: post.user
  end

  json.section do
    json.partial! "section", section: post.section
  end
  json.likes do
    json.array! post.like_by_users do |user|
      json.id user.id
      json.nick_name user.nick_name
    end
  end
  json.comments do
    json.array! post.comments.where(parent_id: nil).order(created_at: :desc).limit(8) do |comment|
      json.partial! "comment", locals: { comment: comment, detail: defined?(detail) ? true : false }
    end
  end
  json.comments_count post.comments.count

  if post.comments.count > 8
    json.has_more_comments true
    
  else
    json.has_more_comments false
  end
  json.partial! "abilities", object: post
  
end
