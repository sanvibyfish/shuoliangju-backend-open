class Notification < ApplicationRecord
  belongs_to :actor, class_name: "User"
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true
  belongs_to :second_target, polymorphic: true, optional: true
  belongs_to :third_target, polymorphic: true, optional: true



  scope :unread, -> { where(read_at: nil) }
  scope :likes, -> { where(notify_type: "like")}
  scope :comments, -> { where(notify_type: ["comment","reply_comment"])}
  scope :system, -> { where(notify_type: "system")}

  def read?
    self.read_at.present?
  end




  def notify_title
    return "" if self.actor.blank?
    if self.notify_type == "comment"
      "#{self.actor.nick_name} 评论了你"
    elsif self.notify_type == "reply_comment"
      "#{self.actor.nick_name} 回复了你"
    elsif self.notify_type == "like"
      "#{self.actor.nick_name} 赞了你"
    end
  end

  def notify_body
    return "" if self.target.blank?
    if self.target_type == "Post"
      "#{self.target.body}"
    elsif self.target_type == "Article"
      "#{self.target.title}"
    elsif self.target_type == "Comment"
      "#{self.target.body}"
    end
  end

  def notify_avatar_url
    return "" if self.actor.blank?
    "#{self.actor.avatar_url}"
  end

  def Notification.read!(ids = [])
    return if ids.blank?
    Notification.where(id: ids).update_all(read_at: Time.now)
  end

end
