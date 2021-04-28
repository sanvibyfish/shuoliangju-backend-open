module Api
  module V1
    class ArticlesController < Api::V1::ApplicationController
      before_action :verify_user!, except: [:index, :show]
      before_action :current_user, only: [:index, :show]
      before_action :set_page_params, only: [:index]
      load_and_authorize_resource
      
      
      def create
        required_attributes! [:image, :app_id,:title,:content]
        sensitive_words_validates! [:title,:content]
        @article = Article.new(article_params)
        if params[:image].present?
          @article.image.attach(ActiveStorage::Blob.find(params[:image]))
        end
        # 默认是发布状态，以后在做草稿
        @article.state = Article.states[:published]
        @article.save!
        @message = I18n.t("api.message.article.success")
        render "show"
      end
      
      def index
        required_attributes! [:app_id]
        @articles = Article.where(app_id:params[:app_id]).published.order(created_at: :desc).page(params[:page]).per(10)
      end

      def show
        required_attributes! [:id]
        @article = Article.find(params[:id])
        @article.hits.increment
      end

      def like
        required_attributes! [:id]
        @article = Article.find(params[:id])
        @current_user.like_article(@article)
        @current_user.like_article_notification(@article)
        @article.reload
        render "show"
      end

      def unlike
        required_attributes! [:id]
        @article = Article.find(params[:id])
        @current_user.unlike_article(@article)
        render "show"
      end

      def destroy
        required_attributes! [:id]
        @article = Article.find(params[:id])
        @article.destroy!
        render_success!(I18n.t("api.message.article.destroy_success"))
      end



      private


      def set_page_params
        params[:pasge] = 1 if params[:page].blank?
      end
      
      def article_params
        params.permit(:title, :content, :summary, :user_id, :image,:app_id)
      end
    end
  end
end
