module Api
  module V1
    class ProductsController < Api::V1::ApplicationController
      before_action :verify_user!
      load_and_authorize_resource
      
      def create
        required_attributes! [:images, :body]
        sensitive_words_validates! [:body]

        @product = Product.new(product_params)
        if params[:images].present?
          @product.images.attach(ActiveStorage::Blob.find(params[:images]))
        end

        @product.save!
        @message = I18n.t("api.message.product.success")
        render "show"
      end


      def index
        @products = Product.where(user_id: params[:target_user_id]).order(created_at: :desc).page(params[:page]).per(10)
      end

      def destroy
        required_attributes! [:id]
        @product = Product.find(params[:id])
        @product.destroy!
        render_success!(I18n.t("api.message.product.destroy_success"))
      end

      private

      def product_params
        params.permit(:user_id,:images, :body, :price)
      end
    end
  end
end
