require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  include ApiHelpers
  include ControllerMacros

  describe "POST /api/v1/articles.json" do
    it "when params missing" do
      login_user!
      post "/api/v1/articles.json", {app_id: current_app.id}
      expect(json_response["code"]).to eq(400)
    end

    it "when missing app_id" do
      login_user!
      post "/api/v1/articles.json"
      expect(json_response["code"]).to eq(401)
    end

    it "when content invalid" do
      login_user!
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob1 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      post "/api/v1/articles.json", { title: "test",content: "成人电影<p>xxxx</p>",app_id: current_app.id ,image: blob1.id}
      expect(json_response["code"]).to eq(10004)
      expect(json_response["message"]).to eq(I18n.t('error.content_invaild'))
      blob1.purge
    end


    it "when passed" do
      login_user!
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob1 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      post "/api/v1/articles.json", { title: "test",content: "jhkjsdhfnujfhui<p>xxxx</p>",app_id: current_app.id ,image: blob1.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["content"]).to eq("jhkjsdhfnujfhui<p>xxxx</p>")
      blob1.purge
    end
  end

  describe "GET /api/v1/articles.json" do
    it do
      articles = create_list(:article, 5, user: create(:user), app: current_app, state: Article.states[:published])
      login_user!
      get "/api/v1/articles.json", {app_id: current_app.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(5)
    end
  end

  describe "GET /api/v1/articles/:id.json" do
    it do
      article = create(:article, app: current_app)
      login_user!
      get "/api/v1/articles/#{article.id}.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["id"]).to eq(article.id)
    end
  end

  describe "POST /api/v1/articles/:id/like.json" do
    it do
      article = create(:article, app: current_app)
      login_user!
      post "/api/v1/articles/#{article.id}/like.json"
      expect(json_response["data"]["likes_count"]).to eq(1)
    end
  end

  describe "POST /api/v1/articles/:id/unlike.json" do
    it do
      article = create(:article, app: current_app)
      login_user!
      current_user.like_article(article)
      post "/api/v1/articles/#{article.id}/unlike.json"
      expect(json_response["data"]["likes_count"]).to eq(0)
    end
  end

  describe "DELETE /api/v1/posts/:id.json" do
    it "when login own user" do
      article = create(:article, app: current_app, user: current_user)
      login_user!
      delete "/api/v1/articles/#{article.id}.json"
      expect(json_response["message"]).to eq(I18n.t("api.message.article.destroy_success"))
    end
  end
  
end
