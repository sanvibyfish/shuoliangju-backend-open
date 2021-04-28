class Article < ApplicationRecord
  include SoftDelete
  has_one_attached :image
  has_rich_text :content
  belongs_to :account, optional: true
  before_save :set_image_url
  belongs_to :user
  belongs_to :app
  enum state: { overdue: -1, draft: 0, published: 1}
  counter :hits
  has_many :comments, :as => :commentable,dependent: :destroy

  has_many :like_by_user_actions
  has_many :like_by_users, through: :like_by_user_actions

  def set_image_url
    self.image_url = self.image.cdn_service_url if self.image.attached?
  end

  def state_text
    I18n.t("activerecord.enums.article.state.#{self.state}")
  end

  def overdue
    self.update!(state: :overdue)
  end

  def published
    self.update!(state: :published)
  end

end
