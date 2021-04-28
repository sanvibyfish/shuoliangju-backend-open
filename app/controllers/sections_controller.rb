class SectionsController < BaseController
  before_action :set_section, only: [:show, :edit, :update, :destroy]
  before_action :current_app
  breadcrumb "社区管理", -> {app_sections_path(params[:app_id])}
  breadcrumb "板块管理", -> {app_sections_path(params[:app_id])}

  # GET /sections
  # GET /sections.json
  def index
    @q = Section.by_app(params[:app_id]).ransack(params[:q])
    @sections = @q.result.page(params[:page]).per(10)
    @count = @q.result.count
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @section = Section.new
    @app = App.find(params[:app_id])
    @title = "新建板块"
    breadcrumb "新建板块", new_app_section_path
  end

  # GET /sections/1/edit
  def edit
    @title = "修改板块"
    breadcrumb "修改板块", edit_app_section_path(@app, @section)
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(section_params)
    @app = App.find(params[:app_id])
    @section.app = @app
    respond_to do |format|
      if @section.save
        format.html { redirect_to app_sections_url, notice: '创建成功' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to app_sections_url, notice: '更新成功' }
      else
        format.html { render :edit }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to app_sections_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
      @app = @section.app
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.fetch(:section, {}).permit(:name, :icon, :summary, :role)
    end
end
