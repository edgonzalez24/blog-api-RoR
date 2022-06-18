class PostsController < ApplicationController

  # GET /post
  def index
    @post = Post.where(published: true)
    render json: @post, status: :ok
  end

  # GET /post/{id}
  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  end

end