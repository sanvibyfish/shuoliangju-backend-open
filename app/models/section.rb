class Section < ApplicationRecord
  has_one_attached :icon
  belongs_to :app
  before_save :set_icon_url
  enum role: { normal: 0 , admin: 1}, _suffix: true
  
  def role_text
    I18n.t("activerecord.enums.section.role.#{self.role}")
  end

  def set_icon_url
    self.icon_url = self.icon.cdn_service_url if self.icon.attached?
  end
  
end
