require "open-uri"

class User < ApplicationRecord
  include Roles
  has_secure_password
  before_save :save_avatar_url, :set_nick_name, :avatar_url_to_oss
  # for User model
  has_many :like_post_actions
  has_many :like_posts, through: :like_post_actions
  # for User model
  has_many :star_post_actions
  has_many :star_posts, through: :star_post_actions
  # for User model
  has_many :like_article_actions
  has_many :like_articles, through: :like_article_actions

  # mount_uploader :avatar, AvatarUploader
  # validates :email, presence: true, uniqueness: true
  # validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_one_attached :avatar
  validates :cellphone, length: { minimum: 11 }, allow_blank: true
  action_store :like, :post, counter_cache: true
  action_store :star, :post, counter_cache: true
  action_store :like, :comment, counter_cache: true
  action_store :like, :article, counter_cache: true

  action_store :follow, :user, counter_cache: "followers_count", user_counter_cache: "following_count"

  has_many :notifications, dependent: :destroy
  has_many :posts, dependent: :destroy

  has_many :boards
  has_many :apps, through: :boards
  has_many :white_lists, :as => :white_listable,dependent: :destroy



  default_scope { order(created_at: :desc) }

  # validates :password,
  #           length: { minimum: 6 },
  #           if: -> { new_record? || !password.nil? }

  enum state: { normal: 0, admin: 1, blocked: 2}

  value :session_key

  after_commit :refresh_cache
  #举报
  has_many :reports, :as => :reportable,dependent: :destroy

  def actions
    self.reload.white_lists.map(&:action)
    # ["create_app"]
  end

  def refresh_cache
    @redis_user = Redis::Value.new("user:#{self.id}")
    unless @redis_user.value.blank?
      @redis_user.value = self.to_json
    end
  end

  def avatar_url_to_oss
    if !self.avatar.attached? && self.avatar_url.present? && self.avatar_url.start_with?("https://wx.qlogo.cn")
      downloaded_image = open(self.avatar_url)
      self.avatar.attach(io: downloaded_image, filename: "avatar.png")
      self.avatar_url = self.avatar.cdn_service_url
    end
  end

  def save_avatar_url
    self.avatar_url = self.try(:avatar).cdn_service_url if self.try(:avatar).attached?
  end

  def set_nick_name
    self.nick_name = self.name if self.nick_name.blank? && self.name.present?
  end

  def post_count
    Post.where(user_id: self.id).count
  end

  def ban
    self.update!(state: :blocked)
  end

  def unban
    self.update!(state: :normal)
  end

  def set_admin
    self.update!(state: :admin)
  end

  def unset_admin
    self.update!(state: :normal)
  end
  

  def state_text
    I18n.t("activerecord.enums.user.state.#{self.state}")
  end

  def self.current=(user)
    Thread.current[:current_user] = user
  end

  def self.current
    Thread.current[:current_user]
  end


  def like_post_notification(post)
    Notification.create(
      notify_type: "like",
      actor: self,
      user: post.user,
      target: post,
    )
  end

  def like_article_notification(article)
    Notification.create(
      notify_type: "like",
      actor: self,
      user: article.user,
      target: article,
    )
  end

  def like_comment_notification(comment)
    Notification.create(
      notify_type: "like",
      actor: self,
      user: comment.user,
      target: comment,
    )
  end

  def unlike_post_notification(post)
    Notification.create(
      notify_type: "unlike",
      actor: self,
      user: post.user,
      target: post,
    )
  end
end
