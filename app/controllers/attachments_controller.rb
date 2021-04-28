class AttachmentsController < BaseController
  skip_before_action :set_app

  def create
    blob = ActiveStorage::Blob.create_after_upload!(
      io: params[:upload].to_io,
      filename: params[:upload].original_filename,
      content_type: params[:upload].content_type,
    )
    render json: {
      url: blob.cdn_service_url,
      blob_id: blob.id,
    }
  end

  private

  def attachment_params
    params.permit(:upload)
  end
end
