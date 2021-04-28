json.extract! comment, :id, :body, :image_url, :image_url, :likes_count

json.created_at (comment.created_at.to_f * 1000).to_i
json.commentable_id comment.commentable_id
json.commentable_type comment.commentable_type
if @current_user.present?
  json.liked @current_user.find_action(:like, target: comment).blank? ? false : true
end
if defined?(detail)

end

if comment.reply_to
  json.reply_to do
    json.id comment.reply_to.id
    json.user do
      json.partial! "user", user: comment.reply_to.user
    end
  end
end

json.user do
  json.partial! "user", user: comment.user
end


if comment.parent.present?
  json.parent_id comment.parent.id
end

json.children do
  json.array! comment.children.order(created_at: :desc), partial: "comment", as: :comment
end

json.partial! "abilities", object: comment