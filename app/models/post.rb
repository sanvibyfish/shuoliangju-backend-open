class Post < ApplicationRecord
  include SoftDelete, Actions
  belongs_to :user
  belongs_to :app
  belongs_to :section, optional: true
  has_many_attached :images
  has_one_attached :video
  has_many :comments, :as => :commentable,dependent: :destroy
  has_many :like_by_user_actions
  has_many :like_by_users, through: :like_by_user_actions
  has_many :star_by_user_actions
  has_many :star_by_users, through: :star_by_user_actions
  before_save :append_images_url, :append_video_url
  has_many :notifications, :as => :target,  dependent: :destroy
  has_many :second_notifications, :as => :second_target,class_name: "Notification",  dependent: :destroy
  has_many :third_notifications, :as => :third_target,class_name: "Notification",  dependent: :destroy

  #举报
  has_many :reports, :as => :reportable


  
  default_scope { 
    order(created_at: :desc) 
  }

  scope :active, -> { where(state: :active)}
  scope :popular, -> { active.where("likes_count > 5") }
  scope :top, -> {active.where(top: true)}
  scope :current_user_ban_post, -> {where(state: :ban, user: User.current)}
  scope :un_excelude, -> { active.or(current_user_ban_post)}

  def append_images_url
    self.images_url = self.images.map(&:cdn_service_url) if self.images.attached?
  end

  def top_text
    self.top ? '已置顶' : '未置顶'
  end

  def append_video_url
    self.video_url = self.video.cdn_service_url if self.video.attached?
  end
  
end
