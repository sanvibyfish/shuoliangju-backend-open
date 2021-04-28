require "rails_helper"

RSpec.describe "Api::V1::Products", type: :request do
  include ApiHelpers
  include ControllerMacros

  describe "POST /api/v1/products.json" do
    it "when params blank" do
      login_user!
      post "/api/v1/products.json"
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
      post "/api/v1/products.json",{body:"xxx",images:[blob2.id], price: 0}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"]["body"]).to eq("xxx")
      blob2.purge
    end

  end

  describe "GET /api/v1/products.json" do
    it "when all pass" do
      product = create_list(:product, 10, user: current_user, body: "123")
      product2 = create_list(:product, 10, user: current_user, body: "456")
      login_user!

      get "/api/v1/products.json", {target_user_id: current_user.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]["body"]).to eq(product2.first.body)

      get "/api/v1/products.json", {page: 2,target_user_id: current_user.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]["body"]).to eq(product.first.body)
    end

    it "when target_user all pass" do
      target_user = create(:user)
      product = create_list(:product, 10, user: target_user, body: "123")
      product2 = create_list(:product, 10, user: target_user, body: "456")
      login_user!

      get "/api/v1/products.json", {target_user_id:target_user.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]["body"]).to eq(product2.first.body)

      get "/api/v1/products.json", {page: 2,target_user_id:target_user.id}
      expect(json_response["code"]).to eq(200)
      expect(json_response["data"].length).to eq(10)
      expect(json_response["data"][0]["body"]).to eq(product.first.body)
    end
  end


  describe "DELETE /api/v1/product/:id.json" do
    it "delete self product" do
      product = create(:product, user: current_user)
      login_user!
      delete "/api/v1/products/#{product.id}.json"
      expect(json_response["code"]).to eq(200)
      expect(json_response["message"]).to eq(I18n.t(".api.message.product.destroy_success"))
    end

    it "delete other user product" do
      product = create(:product)
      login_user!
      delete "/api/v1/products/#{product.id}.json"
      expect(json_response["code"]).to eq(401)
    end

  end



end
