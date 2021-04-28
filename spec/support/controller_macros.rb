require "cancan/matchers"

module ControllerMacros
  extend ActiveSupport::Concern

  included do
    def login_account
      # Before each test, create and login the user
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        account = FactoryBot.create(:account)
        account.confirm! # Or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
        sign_in account
      end
    end
  
    let(:current_user) { FactoryBot.create(:user) }
    let(:current_app) {FactoryBot.create(:app, own: current_user)}
    let(:token) { JsonWebToken.encode(user_id: current_user.id, exp: (Time.now + 24.hours.to_i * 7).to_i) }
  
  
    def login_user!
      default_headers[:Authorization] = token
      #模拟从redis取出
      user = JSON.parse(current_user.to_json, object_class: User)
    end

    def login_admin_user!
      login_user!
      allow(current_user).to receive(:state) { "admin" }
      allow_any_instance_of(User).to receive(:admin?).and_return(true)
    end
  
    def default_headers
      @default_headers ||= {}
    end
  
    def default_parameters
      @default_parameters ||= {}
    end
  
  
    # 覆盖 get, post .. 方法，让他们自己带上登录信息
    %i[get post put delete head].each do |method|
      class_eval <<~EOV
        def #{method}(path, parameters = nil, headers = nil)
          # override empty params and headers with default
          parameters = combine_parameters(parameters, default_parameters)
          headers = combine_parameters(headers, default_headers)
          super(path, params: parameters, headers: headers)
        end
      EOV
    end
  
    # Not used in this tutorial, but left to show an example of different user types
    def login_admin
      before(:each) do
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in FactoryBot.create(:admin) # Using factory bot as an example
      end
    end
  
    private
  
    def combine_parameters(argument, default)
      # if both of them are hashes combine them
      if argument.is_a?(Hash) && default.is_a?(Hash)
        default.merge(argument)
      else
        # otherwise return not nil arg or eventually nil if both of them are nil
        argument || default
      end
    end
  end



end