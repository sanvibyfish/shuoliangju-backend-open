module ActiveStorageBlobExtension
  extend ActiveSupport::Concern

  included do

    def cdn_service_url
      if ENV['CDN_HOST'].present?
        "#{ENV['CDN_HOST']}/#{self.key}"
      else
        self.service_url
      end 
    end

  end
end