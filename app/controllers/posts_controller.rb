class PostsController < BaseController
  before_action :set_post,  except: [:index, :new, :create]
  before_action :current_app
  breadcrumb "社区管理", -> {app_posts_path(params[:app_id])}
  breadcrumb "帖子管理", -> {app_posts_path(params[:app_id])}

  def index
    @q = Post.by_app(params[:app_id]).ransack(params[:q])
    @posts = @q.result.page(params[:page]).per(10)
    @count = @q.result.count
  end

  def excellent
    @post.excellent!
    redirect_to app_posts_path, notice: '加精成功'
  end

  def unexcellent
    @post.unexcellent!
    redirect_to app_posts_path, notice: '取消加精成功'
  end

  def top
    @post.top!
    redirect_to app_posts_path, notice: '置顶成功'
  end

  def untop
    @post.untop!
    redirect_to app_posts_path, notice: '取消置顶成功'
  end

  def ban
    @post.ban!
    redirect_to app_posts_path, notice: '隐藏成功'
  end


  def unban
    @post.unban!
    redirect_to app_posts_path, notice: '隐藏成功'
  end

  def edit
    breadcrumb "修改帖子", edit_app_post_path(@post.app, @post)
    @post
  end

  def update
    if @post.update!(post_params)
      redirect_to app_posts_path, notice: '更新成功'
    end
  end

  def destroy
    if @post.destroy!
      redirect_to app_posts_path, notice: '删除成功'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.fetch(:post, {}).permit(:body)
  end

end
