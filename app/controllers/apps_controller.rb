class AppsController < BaseController
  skip_before_action :set_app
  # breadcrumb "小程序设置", -> {app_path(params[:app_id])}

  def index
    @apps = App.all
  end

  def create
    @app = App.new(app_params)
    @app.account = current_account
    respond_to do |format|
      if @app.save
        format.html { redirect_to apps_url, notice: '创建成功' }
        format.json { render :show, status: :created, location: @app }
      else
        format.html { render :new }
        format.json { render json: @app.errors, status: :unprocessable_entity }
      end
    end    
  end

  def new
    @app = App.new
  end

  def update
    @app = App.find(params[:id])
    if @app.update(app_params)
      redirect_to edit_app_url, notice: '更新成功'
    else
      render :edit
    end
  end

  def edit
    @app = App.find(params[:id])
    @title = "基本信息"
    @detail = true
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def app_params
      params.fetch(:app, {}).permit(:name, :logo, :summary, :wechat_app_id, :wechat_app_secret)
    end

end
