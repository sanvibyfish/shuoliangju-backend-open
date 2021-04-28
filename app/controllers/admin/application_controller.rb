class Admin::ApplicationController < ApplicationController
    layout "admin"
    before_action :set_page_layout_data
    before_action :authenticate_account!

    protected

        def set_page_layout_data
            @_sidebar_name = "admin"
        end
end
