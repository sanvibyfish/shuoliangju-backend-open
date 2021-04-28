class ApplicationRecord < ActiveRecord::Base
  include Redis::Objects

  self.abstract_class = true
  scope :by_app, ->(app_id) { where(app_id: app_id) }

end
