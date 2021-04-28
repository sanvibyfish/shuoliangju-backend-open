class Comment < ApplicationRecord
  include SoftDelete
  has_one_attached :image
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :app
  belongs_to :reply_to, class_name: "Comment", optional: true
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :children, class_name: "Comment", foreign_key: "parent_id",  dependent: :destroy
  has_many :replies, class_name: "Comment", foreign_key: "reply_to_id", dependent: :destroy
  has_many :like_by_user_actions
  has_many :like_by_users, through: :like_by_user_actions
  before_save :set_image_url

  def set_image_url
    self.image_url = self.image.cdn_service_url if self.image.attached?
  end

  after_commit :create_notifications, on: [:create]
  def create_notifications
    if self.reply_to.blank?
      Notification.create(
        notify_type: "comment",
        actor: self.user,
        user: self.commentable.user,
        target: self,
        second_target: self.commentable)
    else
      Notification.create(
        notify_type: 'reply_comment',
        actor: self.user,
        user: self.reply_to.user,
        target: self,
      second_target: self.parent,
      third_target: self.commentable)
    end
  end

  after_destroy :delete_notifications
  def delete_notifications
    Notification.where(notify_type: ["comment","reply_comment","like"], target: self).delete_all
  end



end
