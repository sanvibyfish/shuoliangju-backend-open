class UsersController < BaseController
  before_action :set_user, except: [:index, :new, :create]
  before_action :current_app
  breadcrumb "社区管理",  ->{app_users_path(params[:app_id])}
  breadcrumb "用户管理", -> {app_users_path(params[:app_id])}

  # GET /users
  # GET /users.json
  def index
    @q = @current_app.users.ransack(params[:q])
    @users = @q.result.page(params[:page]).per(10)
    @count = @q.result.count
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end


  def ban
    @user.ban
    @user.reload
    redirect_to app_users_path, notice: '用户禁用成功'
  end
  
  def unban
    @user.unban
    @user.reload
    redirect_to app_users_path, notice: '用户取消禁用成功'
  end



  def set_admin
    @user.set_admin
    redirect_to app_users_path(@user.app), notice: '设置管理员成功'
  end

  def unset_admin
    @user.unset_admin
    redirect_to app_users_path(@user.app), notice: '取消管理员成功'
  end


  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    redirect_to app_users_path, notice: '用户创建成功'
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    redirect_to app_users_path, notice: '用户删除成功'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:nick_name, :role)
    end

    def search_params
      params.require(:q).permit(:name, :state, :id)
    end
end
