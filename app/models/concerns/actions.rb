# frozen_string_literal: true

module Actions
  extend ActiveSupport::Concern

  included do
    enum grade: { normal: 0, excellent: 1}
    enum state: { ban: -1, active: 0 }

    def grade_text
      I18n.t("activerecord.enums.grade.#{self.grade}")
    end

    def state_text
      I18n.t("activerecord.enums.state.#{self.state}")
    end

    # Follow enum method override methods must in `included` block.

    def ban!(reason: "")
      transaction do
        update!(state: :ban)
      end
    end

    def unban!(reason: "")
      transaction do
        update!(state: :active)
      end
    end


    def excellent!
      transaction do
        update!(grade: :excellent)
      end
    end

    def unexcellent!
      transaction do
        update!(grade: :normal)
      end
    end

    def top!
      transaction do
        update!(top: 1)
      end
    end

    def untop!
      transaction do
        update!(top: 0)
      end
    end



  end

  # 删除并记录删除人
  def destroy_by(user)
    return false if user.blank?
    update_attribute(:who_deleted, user.id)
    destroy
  end

  def destroy
    super
    # delete_notification_mentions
  end
end
