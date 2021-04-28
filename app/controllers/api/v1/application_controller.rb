module Api
    module V1
        class ApplicationController < ActionController::API
            include ActionView::Layouts # if you need layout for .jbuilder
            include ActionController::ImplicitRender # if you need render .jbuilder
            include ExceptionHandler
            include Authentication
            include SensitiveWordsValidates

            layout 'api/v1/application'

            helper_method :can?, :current_ability

            def current_ability
              @current_ability ||= Ability.new(@current_user)
            end

            def can?(*args)
              current_ability.can?(*args)
            end


            def check_content(body)
              if body.present?
                words = $filter_sensitive_word.check(body,1)
                if words.length > 0
                  raise BusinessError.new(I18n.t('api.message.post.body_invalid'),BODY_INVALID) 
                end
                words
              end
            end
            
            def required_attributes!(keys)
                keys.each do |key|
                    raise ActionController::ParameterMissing.new(key) unless params[key].present?
                end
            end


            def qrcode_url(page, scene)
              begin
                raw_response = Wechat.api.wxa_get_wxacode_unlimit(scene, page)
                file = File.open(raw_response.path)
                blob = ActiveStorage::Blob.create_after_upload!(
                  io: file.to_io,
                  filename: file.path,
                  content_type: "image/jpeg"
                )
                @url = blob.cdn_service_url
              rescue Wechat::ResponseError => we
                raise ExceptionHandler::BusinessError.new(we.message,we.error_code) 
              end
            end

        end
    end
end

