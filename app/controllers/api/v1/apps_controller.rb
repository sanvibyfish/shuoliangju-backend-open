module Api
  module V1
    class AppsController < Api::V1::ApplicationController
      before_action :verify_user!, except: [:app_config]
      load_and_authorize_resource

      def create
        required_attributes! [:logo]
        sensitive_words_validates! [:name, :summary]
        @app = App.new(app_params)
        @app.own_id = current_user.id
        @app.users << current_user.reload
        if params[:logo].present?
          @app.logo.attach(ActiveStorage::Blob.find(params[:logo]))
        end
        @app.save!
        @message = I18n.t("api.message.app.success")
        render "show"
      end

      def index
        if current_user.present?
          if params[:target_user_id].present?
            @user = User.find(params[:target_user_id])
            @apps = @user.apps
          else
            @apps = current_user.reload.apps
          end
          
          
        else
          @apps =[]
        end
      end

      def app_config
        @config = {
          help_url: "/pages/article-detail/article-detail?articleId=#{Settings.app_config.help_article_id}&appId=#{Settings.app_config.own_app_id}",
          feedback_url: "/pages/article-detail/article-detail?articleId=#{Settings.app_config.feedback_article_id}&appId=#{Settings.app_config.own_app_id}",
          apply_url: "/pages/article-detail/article-detail?articleId=#{Settings.app_config.apply_article_id}&appId=#{Settings.app_config.own_app_id}"
         }
      end

      def update
        required_attributes! [:id]
        sensitive_words_validates! [:name, :summary]
        @app = App.find(params[:id])
        if params[:logo].present?
          @app.logo.attach(ActiveStorage::Blob.find(params[:logo]))
        end
        @app.update!(app_params.except(:logo))
        @message = I18n.t('api.message.app.update_success')
        render "show"
      end

      def qrcode
        required_attributes! [:id]
        @app = App.find(params[:id])
        if @app.qrcode_url.blank?
          @url = qrcode_url("pages/home/home","appId=#{params[:id]}")
          @app.qrcode_url = @url
          @app.save!
        else
          @url = @app.qrcode_url
        end
      end

      def show
        required_attributes! [:id]
        @app = App.find(params[:id])
      end

      def join
        required_attributes! [:id]
        @app = App.find(params[:id])
        @app.users << current_user.reload
        @app.save!
        @message = "加入成功"
        render "show"
      end

      def exit
        required_attributes! [:id]
        @app = App.find(params[:id])
        @app.users = @app.users.filter{|user| user.id != current_user.id}
        @app.save!
        @message = "退出成功"
        render "show"
      end

      def members
        required_attributes! [:id]
        @members = Board.includes(:user).where(app_id: params[:id]).order(created_at: :asc).page(params[:page]).per(10).map(&:user)
      end

      private

      def app_params
        params.permit(:name, :logo, :summary)
      end
    end
  end
end
