class Product < ApplicationRecord
  has_many_attached :images
  before_save :append_images_url
  belongs_to :user

  def append_images_url
    self.images_url = self.images.map(&:cdn_service_url) if self.images.attached?
  end

end
