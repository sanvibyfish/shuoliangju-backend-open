class ReportsController < BaseController
  before_action :set_report,  except: [:index, :new, :create]
  before_action :current_app
  breadcrumb "社区管理", -> {app_posts_path(params[:app_id])}
  breadcrumb "举报管理", -> {app_reports_path(params[:app_id])}

  def index
    @q = Report.ransack(params[:q])
    @reports = @q.result.page(params[:page]).per(10)
    @count = @q.result.count
  end


  def ignore
    @report.ignore!
    redirect_to app_reports_path, notice: '操作成功'
  end

  def destroy_post
    @report.destroy_post!
    redirect_to app_reports_path, notice: '删除成功'
  end

  def ban_post
    @report.ban_post!
    redirect_to app_reports_path, notice: '隐藏成功'
  end

  def pass_post 
    @report.pass_post!
    redirect_to app_reports_path, notice: '审核通过'
  end


  def ban_user
    @report.ban_user!
    redirect_to app_reports_path, notice: '禁用成功'
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.fetch(:report, {}).permit()
  end

end
