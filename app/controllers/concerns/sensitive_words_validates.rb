
require "openssl"
require "base64"
require "json"
require 'rest-client'

module SensitiveWordsValidates
  extend ActiveSupport::Concern

  included do
    define_method :wechat_biz do
      @wx_biz_data_crypt ||= WxBizDataCrypt.new(Settings.wechat.app_id, Settings.wechat.app_secret)
    end

    define_method :wechat_access_token do
      @redis_access_token = Redis::Value.new("#{Settings.wechat.app_id}:access_token")
      if @redis_access_token.value.blank?
        @access_token = self.wechat_biz.access_token
        @redis_access_token.value = @access_token
      else
        @access_token = @redis_access_token.value
      end
      @access_token
    end
  end

  def sensitive_media_validates!(file)
    begin
        Wechat.api.wxa_img_sec_check(file)
    rescue Wechat::ResponseError => we
      if we.error_code == 87014
        raise ExceptionHandler::BusinessError.new(I18n.t("api.message.post.image_invalid"),10004)
      else
        raise ExceptionHandler::BusinessError.new(we.message,we.error_code) 
      end
    end
  end


  def sensitive_words_validates!(keys)
    keys.each do |key|
      if params[key].present? && params[key].to_s.length > 0
        words = $filter_sensitive_word.check(params[key], 1)
        Rails.logger.info "block words #{words}"
        if words.length > 0
          raise ExceptionHandler::BusinessError.new(I18n.t("api.message.post.body_invalid"), 10004)
        end
        begin
          response = Wechat.api.wxa_msg_sec_check(params[key])
        rescue Wechat::ResponseError => we
          if we.error_code == 87014
            raise ExceptionHandler::BusinessError.new(I18n.t("api.message.post.body_invalid"),10004)
          else
            raise ExceptionHandler::BusinessError.new(we.message,we.error_code) 
          end
        end
      end
    end
  end
end
