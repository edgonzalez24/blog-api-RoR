class PostsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :update]


  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

  # GET /posts
  def index
    @posts = Post.where(published: true)
    if !params[:search].nil? && params[:search].present?
      @posts = PostsSearchService.search(@posts, params[:search])
    end
    render json: @posts.includes(:user), status: :ok
  end

  # GET /posts/{id}
  def show
    @post = Post.find(params[:id])
    if @post.published? || (Current.user && @post.user_id == Current.user.id)
      render json: @post, status: :ok
    else
      render json: {error: 'Not Found'}, status: :not_found
    end
  end

  # POST /posts
  def create
    # This is important to return exeption in the case post was not create and this can handle with exeption handler
    @post = Current.user.posts.create!(create_params)
    render json: @post, status: :created
  end

  # PUT /posts/{id}
  def update
    @post =  Current.user.posts.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok
  end


  private

  # Validation list
  def create_params
    params.require(:post).permit(:title, :content, :published )
  end

  def update_params
    params.require(:post).permit(:title, :content, :published)
  end

  def authenticate_user!
    # Bearer xxxxx
    token_regex = /Bearer(\w+)/
    # read header auth
    headers = request.headers
    # verify if it's validate
    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      token = headers['Authorization'].match(token_regex)[1]
      # Must verify that the token corresponds to a user
      if (Current.user = User.find_by_auth_token(token))
        return
      end
    end

    render json: { error: 'Unauthorized'}, status: :unauthorized
  end
end