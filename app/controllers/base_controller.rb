class BaseController < ApplicationController
    layout "apps"
    before_action :set_page_layout_data
    before_action :authenticate_account!
    before_action :set_app
    
    def check_content(content)
      $filter_sensitive_word.check(content,1)
    end
    
    protected

        def set_page_layout_data
            @_sidebar_name = "apps"
        end

        def set_app
          @app = App.find(params[:app_id])
        end
        

end
