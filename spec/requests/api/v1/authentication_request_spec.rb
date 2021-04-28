require "rails_helper"

RSpec.describe "Api::V1::Authentication", type: :request do
  include ApiHelpers
  include ControllerMacros
  let(:user) { FactoryBot.create(:user) }
  let(:expire_token) { JsonWebToken.encode(user_id: current_user.id, exp: 1) }
  describe "POST /api/v1/auth/login.json" do
    it "when params missing" do
      user
      post "/api/v1/auth/login.json"
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(json_response["code"]).to eq(400)
    end

    it "when user not found" do
      user
      post "/api/v1/auth/login.json", { cellphone: "123456", password: "123456"}
      expect(json_response["code"]).to eq(10002)
    end

    it "when user passed" do
      random_user = create(:random_user)
      post "/api/v1/auth/login.json", { cellphone: random_user.cellphone, password: user.password}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["token"]).not_to be_nil
    end
  end

  describe "POST /api/v1/auth/wechat_login.json" do
    it "when params missing" do
      user
      post "/api/v1/auth/wechat_login.json"
      expect(json_response["code"]).to eq(400)
    end

    context "when first login" do
      it "when user save" do
        @session_key = Redis::Value.new("user:#{user.id}:session_key")
        @session_key.value = "1111"
        allow_any_instance_of(Wechat::MpApi).to receive(:jscode2session).and_return(json({ 'session_key': @session_key, 'openid': user.openid }))
        Wechat.stub(:decrypt).and_return(json({ 'openId': "test_openid", 'nickName': "123", 'avatarUrl': "http://x.com/a", 'city': "", 'gender': 1, 'language': "", 'province': "" }))

        app = create(:app, id: 52)
        board = create(:board, app: app, user: user)
        post "/api/v1/auth/wechat_login.json", { encryptedData: "123", iv: "123", code: "xxx" }
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"]["token"]).not_to be_nil
        expect(json_response["data"]["openid"]).to eq(user.openid)
      end

      it "when user not save" do
        allow_any_instance_of(Wechat::MpApi).to receive(:jscode2session).and_return(json({ 'session_key': "1111", 'openid': "test_openid" }))
        Wechat.stub(:decrypt).and_return(json({ 'openId': "test_openid", 'nickName': "123", 'avatarUrl': "http://x.com/a", 'city': "", 'gender': 1, 'language': "", 'province': "" }))

        app = create(:app, id: 52)
        board = create(:board, app: app, user: user)
        post "/api/v1/auth/wechat_login.json", {  encryptedData: "123", iv: "123", code: "xxx" }
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"]["token"]).not_to be_nil
        expect(json_response["data"]["openid"]).to eq("test_openid")
      end
    end

  end

  describe "get resources" do
    context "has token " do
      it "when token passed" do
        login_user!
        get "/api/v1/users/#{current_user.id}.json"
        expect(json_response["code"]).to eq(200)
      end

      it "when token expired" do
        get "/api/v1/users/info.json", {}, { "Authorization": expire_token }
        expect(json_response["code"]).to eq(10001)
        expect(json_response["message"]).to eq(I18n.t(".api.message.token.expired"))
      end
    end
  end
end
