module Roles
  extend ActiveSupport::Concern

  def roles?(role)
    case role
    when :admin then self.admin?
    when :member then self.normal?
    when :blocked then self.blocked?
    else false
    end
  end

  def newbie?
    self.normal? || self.admin?
  end

end