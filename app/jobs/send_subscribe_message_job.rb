class SendSubscribeMessageJob < ApplicationJob
  queue_as :default
  # rescue_from(ErrorLoadingSite) do
  #   retry_job wait: 5.minutes, queue: :low_priority 
  # end 

  def perform(openids,template_id,page,data,miniprogram_state)
    Rails.logger.info "send message..."

    openids.map { |openid|
      begin
        Wechat.api.subscribe_message_send({touser: openid, template_id: template_id, page: page,data:data,miniprogram_state:miniprogram_state})
        Rails.logger.info("#{template_id} sent #{openid}")
      rescue Wechat::ResponseError => we
        raise ExceptionHandler::BusinessError.new(we.message,we.error_code) 
      end
    }
    
  end
end
