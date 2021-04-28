class CommentsController < BaseController
  before_action :set_comment,  except: [:index, :new, :create]
  before_action :current_app
  breadcrumb "社区管理", -> {app_comments_path(params[:app_id])}
  breadcrumb "评论管理", -> {app_comments_path(params[:app_id])}

  # GET /comments
  # GET /comments.json
  def index
    @q = Comment.by_app(params[:app_id]).ransack(params[:q])
    @comments = @q.result.includes(:commentable).page(params[:page]).per(10)
    @count = @q.result.count
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    redirect_to app_comments_path, notice: '删除成功'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:body, :image_url, :commentable_id, :deleted_at, :user_id, :app_id)
    end
end
