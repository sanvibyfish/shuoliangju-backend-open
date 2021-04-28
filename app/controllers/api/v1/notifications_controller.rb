module Api
  module V1
    class NotificationsController < Api::V1::ApplicationController
      before_action :verify_user!
      load_and_authorize_resource
      def index
      end

      def unread_counts
        if @current_user.present?
          @unread_counts = { likes_unread_count: Notification.where(user_id: @current_user.id).likes.unread.count, 
            comments_unread_count: Notification.where(user_id: @current_user.id).comments.unread.count,
          system_unread_count:  Notification.where(user_id: @current_user.id).system.unread.count}
        else
          @unread_counts = {likes_unread_count:0,comments_unread_count:0,system_unread_count:0}
        end

      end

      def comments
        @notifications = Notification.where(user_id: @current_user.id).comments.order(created_at: :desc).page(params[:page]).per(10)
      end

      def likes
        @notifications = Notification.where(user_id: @current_user.id).likes.order(created_at: :desc).page(params[:page]).per(10)
      end

      def read
        required_attributes! [:ids]
        if params[:ids].any?
          @notifications = @current_user.notifications.where(id: params[:ids])
          Notification.read!(@notifications.collect(&:id))
          @notifications.reload
        end
      end


      private

      def notification_params
        params.permit(:type)
      end
    end
  end
end
