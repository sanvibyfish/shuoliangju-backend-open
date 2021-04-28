class Board < ApplicationRecord
  belongs_to :app, optional: true
  belongs_to :user,optional: true
end
