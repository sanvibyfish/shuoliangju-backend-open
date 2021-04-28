module Api
  module V1
    class GroupsController < Api::V1::ApplicationController
      before_action :verify_user!
      load_and_authorize_resource
      
      def create
        required_attributes! [:logo, :qrcode, :name, :summary, :group_own_wechat]
        @group = Group.new(group_params)
        sensitive_words_validates! [:name,:summary,:group_own_wechat]

        if params[:logo].present?
          @group.logo.attach(ActiveStorage::Blob.find(params[:logo]))
        end

        if params[:qrcode].present?
          @group.qrcode.attach(ActiveStorage::Blob.find(params[:qrcode]))
        end

        @group.save!
        @message = I18n.t("api.message.group.success")
        render "show"
      end


      def index
        if params[:target_user_id].present?
          @groups = Group.where(user_id: params[:target_user_id]).order(created_at: :desc).page(params[:page]).per(10)
        else
          @groups = Group.where(user_id: params[:user_id]).order(created_at: :desc).page(params[:page]).per(10)
        end
        
      end



      def destroy
        required_attributes! [:id]
        @group = Group.find(params[:id])
        @group.destroy!
        render_success!(I18n.t("api.message.group.destroy_success"))
      end


      private

      def group_params
        params.permit(:logo, :qrcode, :name, :summary, :group_own_wechat,:user_id)
      end
    end
  end
end
