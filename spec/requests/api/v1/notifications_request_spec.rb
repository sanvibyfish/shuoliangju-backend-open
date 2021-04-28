require 'rails_helper'

RSpec.describe "Api::V1::Notifications", type: :request do
    include ApiHelpers
    include ControllerMacros

    describe "GET /api/v1/notifications/unread_counts.json" do
      it "renturn comment notifications unread count" do
        login_user!
        other_user = create(:user)
        create_list(:comment_notifications,5, user: current_user, actor: other_user)
        create_list(:reply_comment_notifications,5, user: current_user, actor: other_user)
        get "/api/v1/notifications/unread_counts.json"
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"]["comments_unread_count"]).to eq(10)
      end

      it "renturn like notifications unread count" do
        login_user!
        other_user = create(:user)
        create_list(:like_notifications,10, user: current_user, actor: other_user)
        get "/api/v1/notifications/unread_counts.json"
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"]["likes_unread_count"]).to eq(10)
      end
    end

    describe "GET /api/v1/notifications/comments.json" do
      it "get comments unread list" do
        login_user!
        other_user = create(:user, nick_name: "testuser")
        create_list(:comment_notifications,5, user: current_user, actor: other_user)
        get "/api/v1/notifications/comments.json"
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"].length).to eq(5)

        json_response["data"].map do |item|
          expect(item["notify_title"]).to eq("testuser 评论了你")
          expect(item["read"]).to eq(false)
        end

      end
    end

    describe "GET /api/v1/notifications/comments.json" do
      it "get comments unread list" do
        login_user!
        other_user = create(:user, nick_name: "testuser")
        create_list(:reply_comment_notifications,5, user: current_user, actor: other_user)
        get "/api/v1/notifications/comments.json"
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"].length).to eq(5)

        json_response["data"].map do |item|
          expect(item["notify_title"]).to eq("testuser 回复了你")
          expect(item["read"]).to eq(false)
        end
      end
    end

    describe "GET /api/v1/notifications/likes.json" do
      it "get likes unread list" do
        login_user!
        other_user = create(:user, nick_name: "testuser")
        create_list(:like_notifications,5, user: current_user, actor: other_user)
        get "/api/v1/notifications/likes.json"
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"].length).to eq(5)

        json_response["data"].map do |item|
          expect(item["notify_title"]).to eq("testuser 赞了你")
          expect(item["read"]).to eq(false)
        end
      end
    end

    describe "GET /api/v1/notifications/read.json" do
      it "get likes unread list" do
        login_user!
        other_user = create(:user, nick_name: "testuser")
        likes = create_list(:like_notifications,5, user: current_user, actor: other_user)
        comments = create_list(:comment_notifications,5, user: current_user, actor: other_user)
        reply_comment = create_list(:reply_comment_notifications,5, user: current_user, actor: other_user)
        
        post "/api/v1/notifications/read.json", {ids: likes.map(&:id)}
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"].length).to eq(5)
        json_response["data"].map do |item|
          expect(item["read"]).to eq(true)
        end

        post "/api/v1/notifications/read.json", {ids: comments.map(&:id)}
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"].length).to eq(5)
        json_response["data"].map do |item|
          expect(item["read"]).to eq(true)
        end

        post "/api/v1/notifications/read.json", {ids: reply_comment.map(&:id)}
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"].length).to eq(5)
        json_response["data"].map do |item|
          expect(item["read"]).to eq(true)
        end
      end
    end
 
end