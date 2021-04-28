json.extract! comment, :id, :body, :image_url, :commentable_id, :deleted_at, :user_id, :app_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
