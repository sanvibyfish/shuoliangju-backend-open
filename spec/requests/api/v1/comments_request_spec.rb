require "rails_helper"

RSpec.describe "Api::V1::Comments", type: :request do
  include ApiHelpers
  include ControllerMacros

  describe "POST /api/v1/comments.json" do
    let(:media_post) { FactoryBot.create(:post,app: current_app) }
    let(:article) { FactoryBot.create(:article,app: current_app) }
    let(:other_user) {create(:user)}

    it "when comment to article" do 
      login_user!
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob2 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      post "/api/v1/comments.json", { body: "11111", image: blob2.id, commentable_id: article.id, app_id: current_app.id,commentable_type:"Article"}
      expect(json_response["data"]["image_url"]).not_to be_nil
      expect(json_response["data"]["body"]).to eq("11111")
      blob2.purge
    end

    it "when publish images" do
      login_user!
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob2 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      post "/api/v1/comments.json", { body: "11111", image: blob2.id, commentable_id: media_post.id, app_id: current_app.id }
      expect(json_response["data"]["image_url"]).not_to be_nil
      expect(json_response["data"]["body"]).to eq("11111")
      blob2.purge
    end
    

    it "when body null" do
      login_user!
      file = File.open(Rails.root.join("spec/fixtures/test.png"))
      blob2 = ActiveStorage::Blob.create_after_upload!(
        io: file.to_io,
        filename: "test.png",
        content_type: "image/png",
      )
      post "/api/v1/comments.json", { image: blob2.id,  commentable_id: media_post.id, app_id: current_app.id}
      expect(json_response["data"]["image_url"]).not_to be_nil
      blob2.purge
    end

    it "when params null" do
      login_user!
      post "/api/v1/comments.json"
      expect(json_response["code"]).to eq(400)
    end

    it "when reply to other comment" do
      post = create(:post)
      other_comment = create(:comment,commentable: post)
      login_user!
      post "/api/v1/comments.json", {body:"11111", reply_to_id: other_comment.id, commentable_id: other_comment.commentable.id, app_id: current_app.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]['reply_to']['id']).to eq(other_comment.id)
      expect(json_response["data"]['parent_id']).to eq(other_comment.id)
    end

    it "when reply to other comment have parent" do
      post = create(:post)
      parent_comment = create(:comment,commentable: post)
      other_comment = create(:comment, reply_to: parent_comment, parent: parent_comment,commentable: post)
      login_user!
      post "/api/v1/comments.json", {body:"11111", reply_to_id: other_comment.id, commentable_id: other_comment.commentable.id,app_id: current_app.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]['reply_to']['id']).to eq(other_comment.id)
      expect(json_response["data"]['parent_id']).to eq(parent_comment.id)
    end

    it "when reply user not found" do
      login_user!
      post "/api/v1/comments.json", {body:"11111", reply_to_id: 9999999999, commentable_id: media_post.id,app_id: current_app.id}
      expect(json_response["code"]).to eq(404)
      expect(json_response["message"]).to eq(I18n.t('api.message.comment.nout_found'))
    end
  end

  describe "POST /api/v1/comments/:id/like.json" do
    it do
      post = create(:post)
      comment = create(:comment,commentable: post)
      login_user!
      post "/api/v1/comments/#{comment.id}/like.json"
      expect(json_response["data"]["likes_count"]).to eq(1)
    end
  end

  describe "POST /api/v1/comments/:id/unlike.json" do
    it do
      post = create(:post)
      comment = create(:comment,commentable: post)
      login_user!
      current_user.like_comment(comment)
      post "/api/v1/comments/#{comment.id}/unlike.json"
      expect(json_response["data"]["likes_count"]).to eq(0)
    end
  end

  describe "GET /api/v1/comments.json" do
    it  "when comments ok all case" do
      post = create(:post)
      parent_comment = create(:comment,commentable: post)
      create_list(:comment,10,commentable: post, body: "xxxxx",parent: parent_comment)
      create_list(:comment,4,commentable: post, body: "xxxxx")

      login_user!
      get "/api/v1/comments.json"
      expect(json_response["code"]).to eq(400)
      
      get "/api/v1/comments.json", {commentable_id: post.id}
      expect(json_response["data"].length).to eq(5)
      expect(json_response["data"][0]["commentable_id"].to_i).to eq(post.id)
      json_response["data"].map do |item|
        if item["id"] == parent_comment.id
          expect(item["children"].length).to eq(10)
        end
      end
    end
  end


  describe "DELETE /api/v1/comments/:id.json" do
    it "when comment have children " do
      login_user!

      post = create(:post)
      parent_comment = create(:comment,commentable: post, user: current_user)
      comments = create_list(:comment,10,commentable: post, body: "xxxxx",parent: parent_comment)

      expect(Comment.find_by(id:parent_comment.id).blank?).to eq(false)
      expect(Comment.find_by(id:comments.map(&:id)).blank?).to eq(false)
      delete "/api/v1/comments/#{parent_comment.id}.json"
      expect(json_response["code"]).to eq(200)
      expect(Comment.find_by(id:parent_comment.id).blank?).to eq(true)
      expect(Comment.find_by(id:comments.map(&:id)).blank?).to eq(true)
    end

    it "when comment havenot children " do
      post = create(:post)
      parent_comment = create(:comment,commentable: post, user: current_user)

      login_user!
      delete "/api/v1/comments/#{parent_comment.id}.json"
      expect(json_response["code"]).to eq(200)
      expect(Comment.find_by(id:parent_comment.id).blank?).to eq(true)
    end
  end

end
