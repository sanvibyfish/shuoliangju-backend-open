module ExceptionHandler
  extend ActiveSupport::Concern
  include Api::V1::Code::HttpBase
  include Api::V1::Code::HttpExtend
  included do
    rescue_from(StandardError) do |err|
      Rails.logger.error(err.backtrace.join("\n"))
      render_api_error!(err, HTTP_INTERNAL_SERVER_ERROR)
    end

    rescue_from(BusinessError) do |err|
      Rails.logger.error(err.backtrace.join("\n"))
      render_api_error!(err.message, err.code)
    end

    rescue_from(ActionController::ParameterMissing) do |err|
      Rails.logger.error(err.backtrace.join("\n"))
      render_api_error!(err, HTTP_BAD_REQUEST)
    end

    rescue_from(ActiveRecord::RecordInvalid) do |err|
      Rails.logger.error(err.backtrace.join("\n"))
      render_api_error!(err, HTTP_BAD_REQUEST)
    end
    rescue_from(ActiveRecord::RecordNotUnique) do |err|
      Rails.logger.error(err.backtrace.join("\n"))
      render_api_error!(I18n.t(".api.message.record.not_unique"), HTTP_INTERNAL_SERVER_ERROR)
    end

    rescue_from(ActiveRecord::RecordNotFound) do |err|
      Rails.logger.error(err.backtrace.join("\n"))
      render_api_error!(err, HTTP_NOT_FOUND)
    end

    rescue_from(JWT::ExpiredSignature) do |err|
      Rails.logger.error(err.backtrace.join("\n"))
      render_api_error!(I18n.t(".api.message.token.expired"), TOKEN_EXPIRED)
    end
    

    rescue_from CanCan::AccessDenied do |err|
      Rails.logger.error(err.backtrace.join("\n"))
      render_api_error!(I18n.t(".api.message.permission.access_denied"), HTTP_UNAUTHORIZED)
    end


  end

  

  class BusinessError < StandardError
    attr_reader :message, :code

    def initialize(message, code)
      @code = code
      @message = message
    end
  end

  def error!(data, status_code)
    render :plain => data.to_json, status: status_code, content_type: 'application/json'
  end

  def render_http_error!(messages, status)
    data = { code: status, message: messages }
    error!(data, status)
  end

  def render_api_error!(messages, status)
    data = { code: status, message: messages }
    error!(data, HTTP_OK)
  end

  def render_success!(message)
    data = { code: 200, message: message, data: nil }
    error!(data, HTTP_OK)
  end

  def error_404!
    render_http_error!("Page not found", HTTP_NOT_FOUND)
  end

  def unauthorized!
    render_http_error!("401 Unauthorized", HTTP_UNAUTHORIZED)
  end
end
