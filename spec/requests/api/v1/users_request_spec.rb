require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  include ApiHelpers
  include ControllerMacros
  let(:user) { FactoryBot.create(:user) }

  describe "POST /api/v1/users.json" do
    it "when params missing" do
      post "/api/v1/users.json"
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(json_response["code"]).to eq(400)
    end

    it "when user exist" do
      random_user = create(:random_user)
      post "/api/v1/users.json", { name: "111", cellphone: random_user.cellphone, password: "123123" }
      expect(json_response["code"]).to eq(10000)
    end

    # it "when password less 6 length" do
    #   post "/api/v1/users.json", { name: "111", cellphone: "12345678901", password: "1111" }
    #   expect(json_response["code"]).to eq(400)
    # end

    it "when cellphone less 11 length" do
      post "/api/v1/users.json", { name: "111", cellphone: "123456", password: "111111" }
      expect(json_response["code"]).to eq(400)
    end

    it "when success" do
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob1 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      login_admin_user!
      post "/api/v1/users.json", { name: "111", cellphone: "12312312301", password: "111111", avatar: blob1.id }
      expect(json_response["code"]).to eq(200)
      expect(json_response["message"]).to eq(I18n.t("api.message.user.reigster_success"))
      expect(json_response["data"]["avatar_url"]).not_to be_nil
      blob1.purge
    end
  end

  describe "PUT /api/v1/users.json" do
    it "when success" do
      login_user!
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob1 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      put "/api/v1/users/#{current_user.id}.json", { avatar: blob1.id, nick_name: "test1", city: "shanghai" }
      expect(json_response["code"]).to eq(200)
      expect(json_response["message"]).to eq(I18n.t("api.message.user.update_success"))
      expect(json_response["data"]["avatar_url"]).not_to be_nil
      expect(json_response["data"]["nick_name"]).to eq("test1")
      expect(json_response["data"]["city"]).to eq("shanghai")
      blob1.purge
    end
  end

  describe "GET /api/v1/users/{:id}.json" do
    it do
      other_user = user
      login_user!
      get "/api/v1/users/#{other_user.id}.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["id"]).to eq(other_user.id)
    end

    it "when user not found" do
      login_user!
      get "/api/v1/users/#{123}.json"
      expect(json_response["code"]).to eq(404)
    end
  end

  describe "GET /api/v1/users/info.json" do
    it "show user info" do
      @user = login_user!
      get "/api/v1/users/info.json"
      expect(json_response["data"]["id"]).to eq(@user.id)
    end
  end

  describe "POST /api/v1/users/:id/follow.json" do
    it do
      user = create(:user)
      login_user!
      post "/api/v1/users/#{user.id}/follow.json"
      expect(json_response["data"]["followers_count"]).to eq(1)

      get "/api/v1/users/info.json"
      expect(json_response["data"]["following_count"]).to eq(1)
    end
  end

  describe "POST /api/v1/users/:id/unfollow.json" do
    it do
      user = create(:user)
      login_user!
      current_user.follow_user(user)
      post "/api/v1/users/#{user.id}/unfollow.json"
      expect(json_response["data"]["followers_count"]).to eq(0)

      get "/api/v1/users/info.json"
      expect(json_response["data"]["following_count"]).to eq(0)
    end
  end

  describe "POST /api/v1/users/:id/report.json" do
    let(:other_user) { FactoryBot.create(:user) }
    it "when login admin user" do
      login_admin_user!
      post "/api/v1/users/#{other_user.id}/report.json"
      expect(json_response["data"]).not_to be_nil
    end

    it "when login normal user" do
      login_user!
      post "/api/v1/users/#{other_user.id}/report.json"
      expect(json_response["data"]).not_to be_nil
    end
  end


  describe "POST /api/v1/users/:id/ban.json" do
    it do
      user = create(:user)
      login_admin_user!
      current_user.follow_user(user)
      post "/api/v1/users/#{user.id}/ban.json"
      expect(json_response["data"]["state"]).to eq("blocked")
    end
  end

  describe "POST /api/v1/users/:id/unban.json" do
    it do
      user = create(:user, state: "blocked")
      login_admin_user!
      current_user.follow_user(user)
      post "/api/v1/users/#{user.id}/unban.json"
      expect(json_response["data"]["state"]).to eq("normal")
    end
  end

  describe "GET /api/v1/users/like_posts.json" do
    it do
      post1 = create(:post)
      post2 = create(:post)
      post3 = create(:post)
      login_user!
      current_user.like_post(post1)
      current_user.like_post(post2)
      current_user.like_post(post3)
      get "/api/v1/users/#{current_user.id}/like_posts.json"
      expect(json_response["data"].length).to eq(3)
    end
  end

  describe "GET /api/v1/users/followers.json" do
    it do
      user = create(:user)
      login_user!
      user.follow_user(current_user)
      get "/api/v1/users/#{current_user.id}/followers.json"
      expect(json_response["data"].length).to eq(1)
      expect(json_response["data"][0]["id"]).to eq(user.id)
    end
  end

  describe "GET /api/v1/users/following.json" do
    it do
      user = create(:user)
      login_user!
      current_user.follow_user(user)
      get "/api/v1/users/#{current_user.id}/following.json"
      expect(json_response["data"].length).to eq(1)
      expect(json_response["data"][0]["id"]).to eq(user.id)
    end
  end

  describe "GET /api/v1/users/star_posts.json" do
    it do
      post1 = create(:post)
      post2 = create(:post)
      login_user!
      current_user.star_post(post1)
      current_user.star_post(post2)
      get "/api/v1/users/#{current_user.id}/star_posts.json"
      expect(json_response["data"].length).to eq(2)
    end
  end

  describe "GET /api/v1/users/posts.json" do
    it do
      login_user!
      post1 = create(:post, user: current_user)
      post2 = create(:post, user: current_user)
      get "/api/v1/users/#{current_user.id}/posts.json"
      expect(json_response["data"].length).to eq(2)
      expect(json_response["data"][0]["user"]["id"]).to eq(current_user.id)
    end
  end
end
