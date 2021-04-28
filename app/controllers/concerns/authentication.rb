module Authentication
  extend ActiveSupport::Concern
  include Api::V1::Code::HttpBase
  include Api::V1::Code::HttpExtend

  def current_user
    header = request.headers["Authorization"]
    if header.present?
      header = header.split(" ").last if header
      @decoded = JsonWebToken.decode(header)
      @redis_user = Redis::Value.new("user:#{@decoded[:user_id]}")
      if @redis_user.value.blank?
        @current_user = User.find(@decoded[:user_id])
        @redis_user.value = @current_user.to_json
      else
        @current_user =  JSON.parse(@redis_user.value, object_class: User)
      end
      params[:user_id] = @current_user.id
      User.current = @current_user
      @current_user
    end
  end

  def verify_user!
    begin
      @current_user = current_user
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error(e.backtrace.join("\n"))
      render_api_error!(e, HTTP_UNAUTHORIZED)
    rescue JWT::ExpiredSignature => e
      Rails.logger.error(e.backtrace.join("\n"))
      render_api_error!(I18n.t(".api.message.token.expired"), TOKEN_EXPIRED)
    rescue JWT::DecodeError => e
      Rails.logger.error(e.backtrace.join("\n"))
      render_api_error!(I18n.t(".api.message.token.invalid"), TOKEN_INVALID)
    end
  end

end
