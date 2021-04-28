module Api
  module V1
    class CommentsController < Api::V1::ApplicationController
      before_action :verify_user!, except: [:index]
      before_action :current_user, only: [:index]
      after_action :send_comment_message, only: [:create]
      load_and_authorize_resource
      def index
        required_attributes! [:commentable_id]
        if params[:commentable_type].blank?
          params[:commentable_type] = "Post"
        end
        @comments = Comment.where(parent: nil, commentable_id: params[:commentable_id],commentable_type: params[:commentable_type] ).order(created_at: :desc).page(params[:page]).per(10)
      end

      def create
        required_attributes! [:commentable_id]

        if params[:body].blank? && params[:image].blank?
          raise ActionController::ParameterMissing.new("评论内容或者图片")
        end

        sensitive_words_validates! [:body]

        if params[:commentable_type] == "Article"
          @article = Article.find(params[:commentable_id])
          @comment = @article.comments.new(comment_params)
          @comment.app = @article.app
        else
          @post = Post.find(params[:commentable_id])
          @comment = @post.comments.new(comment_params)
          @comment.app = @post.app
        end
        if params[:reply_to_id].present?
          @reply = Comment.includes(:user).find_by(id:params[:reply_to_id])
          if @reply.blank?
            raise BusinessError.new(I18n.t('api.message.comment.nout_found'),HTTP_NOT_FOUND) 
          else
            @comment.reply_to = @reply
            if @reply.parent.present?
              @comment.parent = @reply.parent
            else
              @comment.parent = @reply
            end
          end
        end
        if params[:image].present? && !@comment.image.attached?
          @comment.image.attach(ActiveStorage::Blob.find(params[:image]))
        end
        @comment.save!
        @message = I18n.t("api.message.comment.success")
        render "show"
      end

      def like
        required_attributes! [:id]
        @comment = Comment.find(params[:id])
        @current_user.like_comment(@comment)
        @current_user.like_comment_notification(@comment)
        render "show"
      end

      def destroy
        required_attributes! [:id]
        @comment = Comment.find(params[:id])
        @comment.destroy!
        render_success!(I18n.t("api.message.comment.destroy_success"))
      end

      def unlike
        required_attributes! [:id]
        @comment = Comment.find(params[:id])
        @current_user.unlike_comment(@comment)
        render "show"
      end

      private

      def comment_params
        params.permit(:body, :app_id, :user_id,:reply_to_id,:parent_id,:commentable_id, :commentable_type)
      end
      
      def send_comment_message
        if params[:commentable_type] == "Article"
          page = "pages/article-detail/article-detail?articleId=#{@comment.commentable_id}"
          thing1_body = @comment.commentable.content.body.length > 10 ? "#{@comment.commentable.content.body[0..10]}..." : @comment.commentable.content.body
        else
          page = "pages/post-detail/post-detail?postId=#{@comment.commentable_id}"
          thing1_body = @comment.commentable.body.length > 10 ? "#{@comment.commentable.body[0..10]}..." : @comment.commentable.body
        end
        if @comment.reply_to.blank?
          openids = [@comment.commentable.user.openid]
          template_id = Settings.wechat.template.reply

          if @comment.body.present?
            thing2_body = @comment.body.length > 10 ? "#{@comment.body[0..10]}..." : @comment.body 
          else
            thing2_body = ''
          end

          data = {thing1: {value:thing1_body}, thing2: { value: thing2_body }, thing3: { value: @comment.user.nick_name} ,  time4: {value: @comment.created_at.strftime('%Y-%m-%d %H:%M')} }
        else
          
          if @comment.body.present?
            thing2_body = @comment.body.length > 10 ? "#{@comment.body[0..10]}..." : @comment.body 
          else
            thing2_body = ''
          end

          if @comment.reply_to.body.present?
            reply_thing1_body = @comment.reply_to.body.length > 10 ? "#{@comment.reply_to.body[0..10]}..." :  @comment.reply_to.body
          else
            reply_thing1_body = ''
          end

          openids = [@comment.reply_to.user.openid]
          template_id = Settings.wechat.template.reply
          data = {thing1: {value: reply_thing1_body}, thing2: { value: thing2_body}, thing3: { value: @comment.user.nick_name}  , time4: {value: @comment.created_at.strftime('%Y-%m-%d %H:%M')} }
        end
        miniprogram_state = Settings.wechat.miniprogram_state
        SendSubscribeMessageJob.perform_later(openids,template_id,page,data,miniprogram_state)
      end



    end
  end
end