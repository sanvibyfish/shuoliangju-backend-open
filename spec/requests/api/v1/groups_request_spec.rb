require "rails_helper"

RSpec.describe "Api::V1::Groups", type: :request do
  include ApiHelpers
  include ControllerMacros

  describe "POST /api/v1/groups.json" do
    it "when params blank" do
      login_user!
      post "/api/v1/groups.json"
      expect(json_response["code"]).to eq(400)
    end

    it "when params not blank" do
      login_user!
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob2 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      post "/api/v1/groups.json", {name: "xxx",summary:"xxx",logo: blob2.id, qrcode: blob2.id, group_own_wechat: "xxx", app_id: current_app.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["name"]).to eq("xxx")
      blob2.purge
    end

  end

  describe "GET /api/v1/groups.json" do
    it "when all pass" do
      groups = create_list(:group, 10, user: current_user, name: "123")
      groups2 = create_list(:group, 10, user: current_user, name: "456")
      login_user!

      get "/api/v1/groups.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]["name"]).to eq(groups2.first.name)

      get "/api/v1/groups.json", {page: 2}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]["name"]).to eq(groups.first.name)
    end

    it "when target_user all pass" do
      target_user = create(:user)
      groups = create_list(:group, 10, user: target_user, name: "123")
      groups2 = create_list(:group, 10, user: target_user, name: "456")
      login_user!

      get "/api/v1/groups.json", {target_user_id:target_user.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]["name"]).to eq(groups2.first.name)

      get "/api/v1/groups.json", {page: 2,target_user_id:target_user.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]["name"]).to eq(groups.first.name)
    end
  end


  describe "DELETE /api/v1/groups/:id.json" do
    it "delete self group" do
      group = create(:group, user: current_user)
      login_user!
      delete "/api/v1/groups/#{group.id}.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["message"]).to eq(I18n.t(".api.message.group.destroy_success"))
    end

    it "delete other user group" do
      group = create(:group)
      login_user!
      delete "/api/v1/groups/#{group.id}.json"
      expect(json_response["code"]).to eq(401)
    end

  end



end
