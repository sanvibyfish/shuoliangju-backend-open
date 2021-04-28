class Group < ApplicationRecord
  has_one_attached :logo
  has_one_attached :qrcode
  before_save :append_logo_url, :append_qrcode_url
  belongs_to :user

  def append_logo_url
    self.logo_url = self.logo.cdn_service_url if self.logo.attached?
  end

  def append_qrcode_url
    self.qrcode_url = self.qrcode.cdn_service_url if self.qrcode.attached?
  end

end
