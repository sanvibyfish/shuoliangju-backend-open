class WhiteList < ApplicationRecord
  belongs_to :white_listable, polymorphic: true
end
