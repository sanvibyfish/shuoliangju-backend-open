module Api
  module V1
    class SectionsController < Api::V1::ApplicationController
      before_action :verify_user!, only: [:create]
      load_and_authorize_resource only: [:create]
      
      def create
        required_attributes! [:name]
        sensitive_words_validates! [:name]
        @section = Section.new(section_params)
        if params[:icon].present? && !@section.icon.attached?
          @section.icon.attach(ActiveStorage::Blob.find(params[:icon]))
        end
        @section.save!
        render "show"
      end

      def index
        required_attributes! [:app_id]
        @sections = Section.where(app_id:params[:app_id]).order(sort: :desc, created_at: :desc)
      end

      private

      def section_params
        params.permit(:name, :sort, :app_id)
      end
    end
  end
end
