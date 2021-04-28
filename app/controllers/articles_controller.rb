class ArticlesController < BaseController
  before_action :set_article,  except: [:index, :new, :create]
  before_action :current_app
  breadcrumb "社区管理", -> {app_articles_path(params[:app_id])}
  breadcrumb "文章管理", -> {app_articles_path(params[:app_id])}
  # GET /articles
  # GET /articles.json
  def index
    @q = Article.by_app(params[:app_id]).ransack(params[:q])
    @articles = @q.result.page(params[:page]).per(10)
    @count = @q.result.count
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    render :layout => false
  end

  # GET /articles/new
  def new
    @article = Article.new
    @title = "新建文章"
    breadcrumb "新建文章", new_app_article_path
  end

  def overdue
    @article.overdue
    redirect_to app_articles_path, notice: '作废成功'
  end

  def published
    @article.published
    redirect_to app_articles_path, notice: '发布成功'
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    @app = App.find(params[:app_id])
    @article.account = current_account
    @article.app = @app
    words = check_content(@article.content.body)
    if words.length > 0 
      render :new, danger: I18n.t('error.content_invaild')
    else
      if @article.save
        redirect_to app_articles_path, notice: '文章创建成功'
      else
        render :new
      end
    end

  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    words = check_content(params[:article][:content])
    if words.length > 0 
      flash[:danger] = I18n.t('error.content_invaild')
      @article.content.body = params[:article][:content]
      render :edit
    else
      if @article.update(article_params)
        redirect_to app_articles_path, notice: '更新成功'
      else
        render :edit
      end
    end

  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    redirect_to app_articles_path, notice: '文章删除成功'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :content, :summary, :user_id, :image)
    end
end
