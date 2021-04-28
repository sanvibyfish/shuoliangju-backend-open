require 'rails_helper'

RSpec.describe "Api::V1::Attachments", type: :request do
    include ApiHelpers
    include ControllerMacros

    describe "POST /api/v1/attachments.json" do
        it do
            login_user!
            post "/api/v1/attachments.json", { file: fixture_file_upload(Rails.root.join("spec/fixtures/test.png"))}, { 'content-type' => 'multipart/form-data' }
            expect(json_response['code']).to eq(200)  
            expect(json_response['data']['blob_id']).not_to be_nil
            
            ActiveStorage::Blob.find(json_response['data']['blob_id']).purge
        end
    end

end