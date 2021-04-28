module Api
  module V1
    class AuthenticationController < Api::V1::ApplicationController
      wechat_api
      before_action :verify_user!, except: [:login, :wechat_login]
      # POST /auth/login
      def login
        required_attributes! [:cellphone, :password]
        @user = User.find_by(cellphone: params[:cellphone])
        if @user&.authenticate(params[:password])
          time = Time.now + 24.hours.to_i * 7
          @current_user = @user
          @token = { token: JsonWebToken.encode(user_id: @user.id, exp: time.to_i), exp: time.strftime("%m-%d-%Y %H:%M"),
                    cellphone: @user.cellphone, user: @user }
        else
          raise BusinessError.new I18n.t(".api.message.user.auth_fail"), USER_AUTH_FAIL
        end
      end

      def wechat_login
        required_attributes! [:encryptedData, :iv, :code]
        data = Wechat.api.jscode2session(params[:code])
        openid = data["openid"]
        @user = User.find_by(openid: openid)
        if @user.present?
          if data.present? && data["session_key"].present?
            @user.session_key = data["session_key"]
          end
          raise BusinessError.new I18n.t(".api.message.wechat.session_key_not_found"), WECAT_SESSION_KEY_NOT_FOUND if @user.session_key.value.blank?
          Rails.logger.info("params[:encryptedData]:#{params[:encryptedData]}, params[:iv]:#{params[:iv]}, @user.session_key.value: #{@user.session_key.value}")
          user_info = Wechat.decrypt(params[:encryptedData],@user.session_key.value,params[:iv])
        else
          user_info = Wechat.decrypt(params[:encryptedData],data["session_key"],params[:iv])
          @user = User.new(openid: user_info["openId"], nick_name: user_info["nickName"],
                           country: user_info["country"],
                           avatar_url: user_info["avatarUrl"], city: user_info["city"], gender: user_info["gender"],
                           language: user_info["language"], province: user_info["province"], password: "12345678")
          @user.save!
          @user.session_key = data["session_key"]
        end
        time = Time.now + 24.hours.to_i * 7
        @current_user = @user
        
        # 额外逻辑，默认加入官方社区
        @app = App.find(Settings.app_config.own_app_id)
        unless Board.where(user_id: @current_user.id, app_id: @app.id).first.present?
          @app.users << @current_user
          @app.save!
        end
        #删除redis
        @redis_user = Redis::Value.new("user:#{@current_user.id}")
        @redis_user.delete
        @token = { token: JsonWebToken.encode(user_id: @user.id, exp: time.to_i), exp: time.strftime("%m-%d-%Y %H:%M"),
                  openid: @user.openid, user: @user }
      end

    end
  end
end
