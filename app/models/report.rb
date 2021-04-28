class Report < ApplicationRecord
  belongs_to :user
  belongs_to :app
  belongs_to :reportable, polymorphic: true

  enum state: { undisposed: 0, disposed: 1}
  enum action: { none:0, ignore: 1, delete: 2, ban: 3, pass:4}, _suffix: true


  def ignore!
    self.update!(state: :disposed, action: :ignore)
  end

  def destroy_post!
    if self.reportable.present?
      transaction do
        self.reportable.destroy
        update!(state: :disposed, action: :delete)
      end    
    end

  end

  def pass_post!
    transaction do
      self.reportable.unban
      update!(state: :disposed, action: :pass)
    end
  end



  def ban_post!
    transaction do
      self.reportable.ban!
      update!(state: :disposed, action: :ban)
    end 
  end
  
  def ban_user!
    transaction do
      self.reportable.ban
      update!(state: :disposed, action: :ban)
    end 
  end

end
