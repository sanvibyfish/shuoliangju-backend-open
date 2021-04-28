module Api
  module V1
    class AttachmentsController < Api::V1::ApplicationController
      before_action :verify_user!

      def create
        required_attributes! [:file]
        sensitive_media_validates! params[:file]

        blob = ActiveStorage::Blob.create_after_upload!(
          io: params[:file].to_io,
          filename: params[:file].original_filename,
          content_type: params[:file].content_type,
        )
        # 内容安全检测
        @attachment = {
          url: blob.cdn_service_url,
          blob_id: blob.id,
        }
      end

      private

      def attachment_params
        params.permit(:file)
      end
    end
  end
end
