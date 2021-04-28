module Api
    module V1
        class UsersController < Api::V1::ApplicationController
            before_action :verify_user!, except: [:create, :show]
            before_action :current_user, only: [:show]
            load_and_authorize_resource except: :create

            def create
                required_attributes! [:name, :cellphone, :password]
                sensitive_words_validates! [:name]
                @user = User.new(user_params)
                if params[:avatar].present?
                  @user.avatar.attach(ActiveStorage::Blob.find(params[:avatar]))
                end
                begin
                    @user.save!
                    @message = I18n.t('api.message.user.reigster_success')
                    @current_user = @user
                    render "show"
                rescue ActiveRecord::RecordNotUnique => e
                    raise BusinessError.new(I18n.t('api.message.user.presenced'),USER_PRESENCED)
                end
            end

            def show
                required_attributes! [:id]
                @user = User.find(params[:id])
            end

            def update
                required_attributes! [:id]
                @user = User.find(params[:id])
                sensitive_words_validates! [:nick_name, :cellphone,  :gender, :province, :city, :prefecture, :identity, :summary, :wechat, 
                  :school,:labels,:company, :company_address, :email, 
                  :toutiao, :wechat_mp, :bilibili,:weibo]

                if params[:avatar].present?
                  @user.avatar.attach(ActiveStorage::Blob.find(params[:avatar]))
                end
                @user.update!(user_params.except(:avatar))
                @message = I18n.t('api.message.user.update_success')
                render "show", details: true
            end

            def info
                @user = @current_user.reload
            end
        

            def follow
              required_attributes! [:id]
              @user = User.find(params[:id])
              @current_user.follow_user(@user)
              @user.reload
              render "show"
            end

            def ban
              required_attributes! [:id]
              @user = User.find(params[:id])
              @user.ban
              @user.reload
              @message = "禁用用户成功"
              render "show"
            end
            
            def unban
              required_attributes! [:id]
              @user = User.find(params[:id])
              @user.unban
              @user.reload
              @message = "取消禁用用户成功"
              render "show"
            end
            

            def unfollow
              required_attributes! [:id]
              @user = User.find(params[:id])
              @current_user.unfollow_user(@user)
              @user.reload
              render "show"
            end

            def like_posts
              required_attributes! [:id]
              @user = User.find(params[:id])
              @posts = @user.like_posts.order(created_at: :desc).page(params[:page]).per(10)
            end

            def posts
              required_attributes! [:id]
              @user = User.find(params[:id])
              @posts = @user.posts.order(created_at: :desc).page(params[:page]).per(10)
            end

            def followers
              required_attributes! [:id]
              @user = User.find(params[:id])
              @users = @user.follow_by_users.order(created_at: :desc).page(params[:page]).per(10)
            end
          
            def following
              required_attributes! [:id]
              @user = User.find(params[:id])
              @users = @user.follow_users.order(created_at: :desc).page(params[:page]).per(10)
            end

            def report
              required_attributes! [:id]
              @user = User.find(params[:id])
              @user.reports.create(user: @current_user, app_id: params[:app_id]) 
              render "show"
            end

            def add_white_list
              required_attributes! [:id]
              @user = User.find(params[:id])
              @user.white_lists.create(action: "create_app")
              render "show"
            end
      


            def star_posts
              required_attributes! [:id]
              @user = User.find(params[:id])
              @posts = @user.star_posts.order(created_at: :desc).page(params[:page]).per(10)
            end

            private
                def user_params
                    params.permit(:name, :avatar, :cellphone, :password, :app_id, :role, :nick_name, :gender, :province, :city, :prefecture, :identity, :summary, :wechat, 
                      :school,:labels,:company, :company_address, :email, 
                      :toutiao, :wechat_mp, :bilibili,:weibo)
                end
        end
        
    end
end
