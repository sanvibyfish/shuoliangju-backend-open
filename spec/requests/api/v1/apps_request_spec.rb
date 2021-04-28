require "rails_helper"

RSpec.describe "Api::V1::Apps", type: :request do
  include ApiHelpers
  include ControllerMacros

  describe "POST /api/v1/apps/:id/qrcode.json" do
    it "when qrcode blank" do
      login_user!
      app = create(:app)
      allow_any_instance_of(Api::V1::ApplicationController).to receive(:qrcode_url).and_return("http://xx.com")
      post "/api/v1/apps/#{app.id}/qrcode.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["url"]).to eq("http://xx.com")
    end

    it "when qrcode not blank" do
      login_user!
      app = create(:app, qrcode_url: "http://xx.com")
      post "/api/v1/apps/#{app.id}/qrcode.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["url"]).to eq("http://xx.com")
    end
  end

  describe "PUT /api/v1/apps/:id.json" do
    it "when own update app info" do
      login_user!
      my_app = create(:app, own: current_user)
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob2 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      put "/api/v1/apps/#{my_app.id}.json", { name: "abc", summary: "aaaa", logo: blob2.id }
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["name"]).to eq("abc")
      expect(json_response["data"]["own"]["id"]).to eq(current_user.id)
      expect(json_response["data"]["logo_url"]).not_to be_nil
      expect(json_response["data"]["summary"]).to eq("aaaa")
      blob2.purge
    end

    it "when normal user update app info" do
      login_user!
      my_user = create(:user)
      my_app = create(:app, own: my_user)
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob2 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      put "/api/v1/apps/#{my_app.id}.json", { name: "abc", summary: "aaaa", logo: blob2.id }
      expect(json_response["code"]).to eq(401)
      blob2.purge
    end
  end

  describe "POST /api/v1/apps/:id/exit.json" do
    it " when user not join" do
      login_user!
      other_user = create(:user)
      my_app = create(:app, own: other_user)
      post "/api/v1/apps/#{my_app.id}/exit.json"
      expect(json_response["code"]).to eq(401)
    end

    it " when user join" do
      login_user!
      my_app = create(:app, own: current_user)
      # board = create(:board, app_id: my_app.id, user_id: current_user.id)
      post "/api/v1/apps/#{my_app.id}/exit.json"
      expect(json_response["code"]).to eq(200)
    end
  end

  describe "POST /api/v1/apps/:id/exit.json" do
    it "when params missing" do
      user1 = create(:user)
      user2 = create(:user)
      my_app = create(:app, own: current_user)
      create(:board, app_id: my_app.id, user_id: user1.id)
      create(:board, app_id: my_app.id, user_id: user2.id)
      login_user!
      get "/api/v1/apps/#{my_app.id}/members.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(3)
      expect(json_response["data"][0]["id"]).to eq(current_user.id)
    end
  end

  describe "POST /api/v1/apps.json" do
    it "when params missing" do
      login_user!
      create(:create_app_white_list, white_listable: current_user)
      post "/api/v1/apps.json"
      expect(json_response["code"]).to eq(400)
    end

    # it "when user not in whitelist" do
    #   login_user!
    #   post "/api/v1/apps.json", { name: "test", summary: "123123" }
    #   expect(json_response["code"]).to eq(401)
    # end

    it "when passed" do
      login_user!
      create(:create_app_white_list, white_listable: current_user)
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob2 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      post "/api/v1/apps.json", { name: "test", summary: "123123", logo: blob2.id }
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["name"]).to eq("test")
      expect(json_response["data"]["own"]["id"]).to eq(current_user.id)
      expect(json_response["data"]["logo_url"]).not_to be_nil
      expect(json_response["data"]["summary"]).to eq("123123")
      blob2.purge
    end
  end

  describe "GET /api/v1/apps.json" do
    it "when current_user logined and target_user_id blank" do
      apps = create_list(:app, 5, own: current_user)
      login_user!
      get "/api/v1/apps.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(5)
      expect(json_response["data"][0]["name"]).to eq(apps.first.name)
      expect(json_response["data"][0]["own"]["id"]).to eq(current_user.id)
    end

    it "when current_user logined and target_user_id not blank" do
      target_user = create(:user)
      apps = create_list(:app, 5, own: target_user)
      login_user!
      get "/api/v1/apps.json", { target_user_id: target_user.id }
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(5)
      expect(json_response["data"][0]["name"]).to eq(apps.first.name)
      expect(json_response["data"][0]["own"]["id"]).to eq(target_user.id)
    end
  end

  describe "GET /api/v1/apps/:id.json" do
    it do
      login_user!
      get "/api/v1/apps/#{current_app.id}.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["id"]).to eq(current_app.id)
    end
  end

  describe "GET /api/v1/apps/app_config.json" do
    it do
      login_user!
      get "/api/v1/apps/app_config.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["help_url"]).not_to be_nil
      expect(json_response["data"]["feedback_url"]).not_to be_nil
    end
  end

  describe "POST /api/v1/apps/{:id}/join.json" do
    it "when not join " do
      app = create(:app)
      login_user!
      post "/api/v1/apps/#{app.id}/join.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["id"]).to eq(app.id)
      expect(App.find(app.id).users.map(&:id)).to include(current_user.id)
    end

    it "when joined " do
      login_user!
      post "/api/v1/apps/#{current_app.id}/join.json"
      expect(json_response["code"]).to eq(401)
    end
  end
end
