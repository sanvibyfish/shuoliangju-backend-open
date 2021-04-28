if notification
    json.(notification,:id, :notify_title, :notify_body, :notify_avatar_url)
    json.created_at (notification.created_at.to_f * 1000).to_i
    json.read notification.read_at.blank? ? false : true
    if notification.target_type == "Comment"
        json.resource_id notification.target.commentable_id
        json.resource_type notification.target.commentable_type
    elsif notification.target_type == "Post"
      json.resource_id notification.target.id
      json.resource_type notification.target_type
    elsif notification.target_type == "Article"
      json.resource_id notification.target.id
      json.resource_type notification.target_type
    end
    json.partial! "abilities", object: notification
end