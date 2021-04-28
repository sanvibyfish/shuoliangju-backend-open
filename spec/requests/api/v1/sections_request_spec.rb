require 'rails_helper'

RSpec.describe "Api::V1::Sections", type: :request do
    include ApiHelpers
    include ControllerMacros

    describe "GET /api/v1/sections.json" do
      let(:section1) {create(:section, name: "first",app: current_app, sort: 999)}
      let(:section2) {create(:section,name: "second", app: current_app)}
      let(:section3) {create(:section,name: "three", app: current_app)}
        it do
            login_user!
            section3
            section2
            section1
            get "/api/v1/sections.json", {app_id: current_app.id}
            expect(json_response['code']).to eq(200)  
            expect(json_response['data'].length).to eq(3)
            expect(json_response['data'][0]['name']).to eq("first")
            expect(json_response['data'][1]['name']).to eq("second")
        end
    end


    describe "POST /api/v1/sections.json" do
      it "when params missing" do
        login_admin_user!
        post "/api/v1/sections.json"
        expect(json_response["code"]).to eq(400)
      end

      it "when have name" do
        login_admin_user!
        post "/api/v1/sections.json",{name: "xxx", app_id: current_app.id}
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"]["name"]).to eq("xxx")
      end

      it "when upload icon" do
        login_admin_user!
        file = File.open(Rails.root.join("spec/fixtures/test.png"))
        blob1 = ActiveStorage::Blob.create_after_upload!(
          io: file.to_io,
          filename: "test.png",
          content_type: "image/png",
        )
        post "/api/v1/sections.json",{name: "xxx", icon: blob1.id, app_id: current_app.id}
        expect(json_response["code"]).to eq(200)
        expect(json_response["data"]["name"]).to eq("xxx")
        expect(json_response["data"]["icon_url"]).not_to be_nil
        blob1.purge
      end
    end
    

end