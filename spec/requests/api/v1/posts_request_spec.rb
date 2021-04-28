require "rails_helper"
require 'tempfile'

RSpec.describe "Api::V1::Posts", type: :request do
  include ApiHelpers
  include ControllerMacros

  let(:section) {create(:section, app: current_app)}

  describe "POST /api/v1/posts/:id/qrcode.json" do
    it "when qrcode blank" do
      login_user!
      post = create(:post)
      allow_any_instance_of(Api::V1::ApplicationController).to receive(:qrcode_url).and_return("http://xx.com")
      post "/api/v1/posts/#{post.id}/qrcode.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["url"]).to eq("http://xx.com")
    end

    it "when access_token in redis" do
      login_user!
      post = create(:post)
      allow_any_instance_of(Wechat::MpApi).to receive(:wxa_get_wxacode_unlimit).and_return(Tempfile.new {})
      allow_any_instance_of(ActiveStorage::Blob).to receive(:cdn_service_url).and_return("http://xx.com")
      post "/api/v1/posts/#{post.id}/qrcode.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["url"]).to eq("http://xx.com")
    end


    it "when wxacodeunlimit exception" do
      login_user!
      post = create(:post)
      allow_any_instance_of(Wechat::MpApi).to receive(:wxa_get_wxacode_unlimit).and_raise(Wechat::ResponseError.new(123,"456"))
      post "/api/v1/posts/#{post.id}/qrcode.json"
      expect(json_response["code"]).to eq(123)
    end

    it "when qrcode not blank" do
      login_user!
      post = create(:post,qrcode_url: "http://xx.com")
      post "/api/v1/posts/#{post.id}/qrcode.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["url"]).to eq("http://xx.com")
    end
  end


  describe "POST /api/v1/posts.json" do

    context  "when section role is admin" do

      it "when normal user" do
        section1 = create(:section, role: Section.roles[:admin])
        login_user!
        post "/api/v1/posts.json",{body: "111", section_id: section1.id}
        expect(json_response["code"]).to eq(401)
      end

      it "when admin user" do
        section1 = create(:section, role: Section.roles[:admin])
        login_admin_user!
        post "/api/v1/posts.json",{body: "111", section_id: section1.id,app_id: current_app.id}
        expect(json_response["code"]).to eq(200)
      end
    end
 

    it "when params missing body and images and videos" do
      login_user!
      post "/api/v1/posts.json",{section_id:section.id}
      expect(json_response["code"]).to eq(400)
      expect(json_response["message"]).to eq("param is missing or the value is empty: body or images or video")
    end

    it "when publish body" do
      login_user!
      post "/api/v1/posts.json", { body: "111", section_id:section.id, app_id: current_app.id}
      expect(json_response["data"]["body"]).to eq("111")
    end

    it "when publish invlaid body" do
      login_user!
      post "/api/v1/posts.json", { body: "成人电影", section_id:section.id, app_id: current_app.id}
      expect(json_response["code"]).to eq(10004)
      expect(json_response["message"]).to eq(I18n.t('api.message.post.body_invalid'))
    end

    it "when publish images" do
      login_user!
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob1 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      blob2 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      post "/api/v1/posts.json", { body: "11111", images: [blob1.id, blob2.id], section_id: section.id,app_id: current_app.id}
      expect(json_response["data"]["images_url"]).not_to be_nil
      blob1.purge
      blob2.purge
    end
  end

  describe "GET /api/v1/posts/{:id}.json" do
    let(:post) { FactoryBot.create(:post) }
    it do
      login_user!
      get "/api/v1/posts/#{post.id}.json"
      expect(json_response["data"]["id"]).to eq(post.id)
    end

    it "when post not found " do
      login_user!
      get "/api/v1/posts/#{9999999999999}.json"
      expect(json_response["code"]).to eq(404)
    end


    it "when images_url valid " do
      image_post = create(:post, images_url: ["http://xxx.com/xxx"])
      login_user!
      get "/api/v1/posts/#{image_post.id}.json"
      expect(json_response["data"]["id"]).to eq(image_post.id)
      expect(json_response["data"]["images_url"][0]).to eq("http://xxx.com/xxx")
    end
    
  end

  

  describe "POST /api/v1/posts/:id/like.json" do
    it do
      post1 = create(:post)
      login_user!
      post "/api/v1/posts/#{post1.id}/like.json"
      expect(json_response["data"]["likes_count"]).to eq(1)
    end
  end

  describe "POST /api/v1/posts/:id/unlike.json" do
    it do
      post2 = create(:post)
      login_user!
      current_user.like_post(post2)
      post "/api/v1/posts/#{post2.id}/unlike.json"
      expect(json_response["data"]["likes_count"]).to eq(0)
    end
  end

  describe "POST /api/v1/posts/:id/star.json" do
    it do
      post1 = create(:post)
      login_user!
      post "/api/v1/posts/#{post1.id}/star.json"
      expect(json_response["data"]["stars_count"]).to eq(1)
    end
  end

  describe "POST /api/v1/posts/:id/unstar.json" do
    it do
      post2 = create(:post)
      login_user!
      current_user.star_post(post2)
      post "/api/v1/posts/#{post2.id}/unstar.json"
      expect(json_response["data"]["stars_count"]).to eq(0)
    end
  end


  describe "POST /api/v1/posts/:id/excellent.json" do
    let(:post1) { FactoryBot.create(:post) }
    it "when login admin user" do
      login_admin_user!
      post "/api/v1/posts/#{post1.id}/excellent.json"
      expect(json_response["data"]["grade"]).to eq("excellent")
    end

    it "when login normal user" do
      login_user!
      post "/api/v1/posts/#{post1.id}/excellent.json"
      expect(json_response["code"]).to eq(401)
      expect(json_response["message"]).to eq(I18n.t(".api.message.permission.access_denied"))
    end
  end


  describe "POST /api/v1/posts/:id/top.json" do
    let(:post1) { FactoryBot.create(:post) }
    it "when login admin user" do
      login_admin_user!
      post "/api/v1/posts/#{post1.id}/top.json"
      expect(json_response["data"]["top"]).to eq(true)
    end

    it "when login normal user" do
      login_user!
      post "/api/v1/posts/#{post1.id}/top.json"
      expect(json_response["code"]).to eq(401)
      expect(json_response["message"]).to eq(I18n.t(".api.message.permission.access_denied"))
    end
  end

  describe "POST /api/v1/posts/:id/untop.json" do
    let(:post1) { FactoryBot.create(:post, top:1) }
    it "when login admin user" do
      login_admin_user!
      post "/api/v1/posts/#{post1.id}/untop.json"
      expect(json_response["data"]["top"]).to eq(false)
    end

    it "when login normal user" do
      login_user!
      post "/api/v1/posts/#{post1.id}/untop.json"
      expect(json_response["code"]).to eq(401)
      expect(json_response["message"]).to eq(I18n.t(".api.message.permission.access_denied"))
    end
  end


  describe "POST /api/v1/posts/:id/ban.json" do
    let(:post1) { FactoryBot.create(:post) }
    it "when login admin user" do
      login_admin_user!
      post "/api/v1/posts/#{post1.id}/ban.json"
      expect(json_response["data"]["state"]).to eq("ban")
    end

    it "when login normal user" do
      login_user!
      post "/api/v1/posts/#{post1.id}/ban.json"
      expect(json_response["code"]).to eq(401)
      expect(json_response["message"]).to eq(I18n.t(".api.message.permission.access_denied"))
    end
  end

  describe "POST /api/v1/posts/:id/unban.json" do
    let(:post1) { FactoryBot.create(:post, top:1) }
    it "when login admin user" do
      login_admin_user!
      post "/api/v1/posts/#{post1.id}/unban.json"
      expect(json_response["data"]["state"]).to eq("active")
    end

    it "when login normal user" do
      login_user!
      post "/api/v1/posts/#{post1.id}/unban.json"
      expect(json_response["code"]).to eq(401)
      expect(json_response["message"]).to eq(I18n.t(".api.message.permission.access_denied"))
    end
  end

  describe "POST /api/v1/posts/:id/report.json" do
    let(:post1) { FactoryBot.create(:post) }
    it "when login admin user" do
      login_admin_user!
      post "/api/v1/posts/#{post1.id}/report.json"
      expect(json_response["data"]).not_to be_nil
    end

    it "when login normal user" do
      login_user!
      post "/api/v1/posts/#{post1.id}/report.json"
      expect(json_response["data"]).not_to be_nil
    end
  end

  describe "DELETE /api/v1/posts/:id.json" do
    let(:post1) { FactoryBot.create(:post) }
    it "when login admin user" do
      login_admin_user!
      delete "/api/v1/posts/#{post1.id}.json"
      expect(json_response["message"]).to eq(I18n.t("api.message.post.destroy_success"))
    end

    it "when login normal user" do
      login_user!
      delete "/api/v1/posts/#{post1.id}.json"
      expect(json_response["code"]).to eq(401)
      expect(json_response["message"]).to eq(I18n.t(".api.message.permission.access_denied"))
    end

    it "when login normal user delete self post" do
      login_user!
      post = create(:post, user: current_user)
      delete "/api/v1/posts/#{post.id}.json"
      expect(json_response["message"]).to eq(I18n.t("api.message.post.destroy_success"))
    end
  end

  describe "POST /api/v1/posts/:id/unexcellent.json" do
    it "when login admin user" do
      excellent_post = create(:post,app: current_app, grade: :excellent)
      login_admin_user!
      post "/api/v1/posts/#{excellent_post.id}/unexcellent.json"
      expect(json_response["data"]["grade"]).to eq("normal")
    end
    it "when login own user" do
      excellent_post = create(:post,app: current_app, grade: :excellent)
      login_user!
      post "/api/v1/posts/#{excellent_post.id}/unexcellent.json"
      expect(json_response["code"]).to eq(200)
    end

    it "when login normal user" do
      excellent_post = create(:post,app: create(:app), grade: :excellent)
      login_user!
      post "/api/v1/posts/#{excellent_post.id}/unexcellent.json"
      expect(json_response["code"]).to eq(401)
      expect(json_response["message"]).to eq(I18n.t(".api.message.permission.access_denied"))
    end

  end

  describe "GET /api/v1/posts/discover.json" do
    let(:posts1) { create_list(:post, 5, app: current_app, body: "page1", user: create(:user)) }
    let(:posts2) { create_list(:post, 5, app: create(:app), body: "page1", user: create(:user)) }
    it "should be ok" do
      posts1
      posts2
      login_user!
      get "/api/v1/posts/discover.json", {page: 1}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]['app_id']).not_to eq(json_response["data"][6]['app_id'])
    end
  end

  describe "GET /api/v1/posts.json" do
    let(:posts1) { create_list(:post, 10, app: current_app, body: "page1") }
    let(:posts2) { create_list(:post, 10, app: current_app, body: "page2") }
    let(:posts3) { create_list(:post, 10, app: current_app, body: "page3") }
    let(:section) { create(:section,app: current_app) }
    let(:section_post) { create(:post,section: section,app: current_app, body:"page4") }
    it "should be ok for all types" do
      other_user = create(:user)
      create_list(:post, 5, app: current_app, body: "page3", user: other_user)
      excellent_post = create(:post,app: current_app, grade: :excellent)
      popular_post = create(:post,app: current_app, likes_count: 10)
      top_post = create(:post,app: current_app, top: 1)
      ban_post1 = create(:post,app: current_app, state: :ban, user:current_user)
      ban_post2 = create(:post,app: current_app, state: :ban, user:other_user)


      login_user!

      get "/api/v1/posts.json", {page: 1, target_user_id: other_user.id,app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(5)
      expect(json_response["data"][0]['user']['id']).to eq(other_user.id)

      get "/api/v1/posts.json", {page: 1,app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(9)
      expect(json_response["data"][0]['user']['id']).to eq(current_user.id)

      get "/api/v1/posts.json", {page: 1, type: "excellent",app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(1)
      expect(json_response["data"][0]['id']).to eq(excellent_post.id)


      get "/api/v1/posts.json", {page: 1, type: "popular",app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(1)
      expect(json_response["data"][0]['id']).to eq(popular_post.id)

      get "/api/v1/posts.json", {page: 1, type: "top",app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(1)
      expect(json_response["data"][0]['id']).to eq(top_post.id)
      

    end

    it "should be ok for page" do
      login_user!
      posts1
      posts2
      posts3

      get "/api/v1/posts.json", {page: 1,app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]['body']).to eq('page3')

      get "/api/v1/posts.json", {app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]['body']).to eq('page3')

      get "/api/v1/posts.json", {page: 2,app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]['body']).to eq('page2')

      get "/api/v1/posts.json", {page: 10,app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(0)

      section_post
      get "/api/v1/posts.json", {page: 1, section_id: section.id,app_id: current_app.id}
      expect(json_response["data"]).not_to be_nil
      expect(json_response["data"].length).to eq(1)
      expect(json_response["data"][0]['body']).to eq('page4')

    end




  end
end
