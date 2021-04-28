require "openssl"
require "base64"
require "json"
require 'rest-client'

class App < ApplicationRecord
  before_create :ensure_app_key!
  value :wechat_access_token, :expiration => 7200.seconds
  has_one_attached :logo
  before_save :set_logo_url

  has_many :boards
  has_many :users, through: :boards

  has_many :posts
  
  belongs_to :own, class_name: "User"
  validates :name, presence: true
  validates :summary, presence: true

  def set_logo_url
    self.logo_url = self.logo.cdn_service_url if self.logo.attached?
  end

  def users_count
    self.users.count
  end

  def posts_count
    self.posts.count
  end

  def ensure_app_key!
    if self.app_key.blank?
      random_key = "slj#{SecureRandom.hex(8)}"
      self.app_key = random_key
    end
  end

  def access_token
    if self.wechat_access_token.blank?
      response = RestClient.get 'https://api.weixin.qq.com/cgi-bin/token', {params: {secret: self.wechat_app_secret, appid: self.wechat_app_id, grant_type: 'client_credential'}}
      raise Exceptions::RemoteError.new(I18n.t('.api.message.system.remote_call_error')) if response.code != 200
      
      data = JSON.parse(response.body)
      
      raise Exceptions::RemoteError.new(I18n.t('.api.message.system.remote_call_error')) if data["errcode"].present? && data["errcode"] != 0
      self.wechat_access_token = data["access_token"]
      data["access_token"]
    else
      self.wechat_access_token.value
    end
  end

  
end
