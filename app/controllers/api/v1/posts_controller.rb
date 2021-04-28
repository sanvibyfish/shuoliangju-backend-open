module Api
  module V1
    class PostsController < Api::V1::ApplicationController
      before_action :verify_user!, except: [:index, :show]
      before_action :current_user, only: [:index, :show]
      before_action :set_page_params, only: [:index]
      after_action :send_like_message, only: [:like]
      after_action :send_new_message, only: [:create]
      load_and_authorize_resource
      
      def index
        args = {}
        if params[:target_user_id].present?
          args[:user_id] = params[:target_user_id]
        else
          required_attributes! [:app_id]
          args[:app_id] = params[:app_id]
        end


        if params[:section_id].present?
          args[:section_id] = params[:section_id]
        end
        if params[:type] == "excellent"
          @posts = Post.send(:where, args).excellent.page(params[:page]).per(10)
        elsif params[:type] == "popular"
          @posts = Post.send(:where, args).popular.page(params[:page]).per(10)
        elsif params[:type] == "top"
          @posts = Post.send(:where, args).top.page(params[:page]).per(10)
        else
          @posts = Post.send(:where, args).un_excelude.page(params[:page]).per(10)
        end
      end

      def discover
        @posts = Post.un_excelude.page(params[:page]).order(created_at: :desc).per(10)
      end

      def create
        if params[:body].blank? && params[:images].blank? && params[:video].blank?
          raise ActionController::ParameterMissing.new("body or images or video")
        end
        sensitive_words_validates! [:body]
        @post = Post.new(post_params)
        if params[:images].present? && !@post.images.attached?
          @post.images.attach(ActiveStorage::Blob.find(params[:images]))
        end

        @post.save!
        @message = I18n.t("api.message.post.success")
        render "show"
      end
      

      def qrcode
        required_attributes! [:id]
        @post = Post.find(params[:id])
        if @post.qrcode_url.blank?
          @url = qrcode_url("pages/post-detail/post-detail","postId=#{params[:id]}")
          @post.qrcode_url = @url
          @post.save!
        else
          @url = @post.qrcode_url
        end
      end

      def show
        required_attributes! [:id]
        @post = Post.find(params[:id])
      end

      def like
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @current_user.like_post(@post)
        @current_user.like_post_notification(@post)
        @post.reload
        render "show"
      end

      def star
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @current_user.star_post(@post)
        @message = "收藏成功"
        render "show"
      end

      def unstar
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @current_user.unstar_post(@post)
        @message = "取消收藏成功"
        render "show"
      end

      def unlike
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @current_user.unlike_post(@post)
        render "show"
      end

      def excellent
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @post.excellent!
        @message = "加精成功"
        render "show"
      end

      def unexcellent
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @post.unexcellent!
        @message = "取消精华成功"
        render "show"
      end


      def top
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @post.top!
        @message = "置顶成功"
        render "show"
      end

      def untop
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @post.untop!
        @message = "取消置顶成功"
        render "show"
      end

      def ban
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @post.ban!
        @message = "隐藏成功"
        render "show"
      end

      def unban
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @post.unban!
        @message = "取消隐藏成功"
        render "show"
      end

      def destroy
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @post.destroy!
        render_success!(I18n.t("api.message.post.destroy_success"))
      end

      def report
        required_attributes! [:id]
        @post = Post.find(params[:id])
        @post.reports.create(user: @current_user, app_id: params[:app_id]) 
        render "show"
      end


      private

      def post_params
        params.permit(:body, :video, :user_id, :app_id,:section_id, :images, :video_url, images_url: [])
      end

      def set_page_params
        params[:pasge] = 1 if params[:page].blank?
      end

      def send_like_message
        openids = [@post.user.openid]
        template_id = Settings.wechat.template.like
        page = "pages/post-detail/post-detail?postId=#{@post.id}"
        data = {thing6: {value:@post.body.length > 10 ? "#{@post.body[0..10]}..." : @post.body}, name1: { value: @current_user.nick_name}, date2: {value: Time.now.strftime('%Y-%m-%d %H:%M')} }
        miniprogram_state = Settings.wechat.miniprogram_state
        SendSubscribeMessageJob.perform_later(openids,template_id,page,data,miniprogram_state)
      end

      def send_new_message
        openids = @post.app.users.map(&:openid)
        template_id = Settings.wechat.template.news
        page = "pages/home/home?appId=#{@post.app.id}"
        data = {thing1: {value:@post.app.name},thing2: {value: @post.body.length > 10 ? "#{@post.body[0..10]}..." : @post.body} , name3: { value: @post.user.nick_name}, date4: {value: Time.now.strftime('%Y-%m-%d %H:%M')} }
        miniprogram_state = Settings.wechat.miniprogram_state
        SendSubscribeMessageJob.perform_later(openids,template_id,page,data,miniprogram_state)
      end
    end
  end
end
