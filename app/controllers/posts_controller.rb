class PostsController < ApplicationController
  include ActionView::Helpers::TextHelper

  before_action :set_post, only: [:edit, :update, :destroy]

  def edit
  end

  def create
    @post = current_user.posts.new(post_params)
    authorize @post
    respond_to do |format|
      if @post.save
        format.html { redirect_to session.delete(:return_to), notice: 'Post was successfully created.' }
        format.json { render 'users/timeline', status: :created, location: session.delete(:return_to) }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to session.delete(:return_to), notice: 'Post was successfully updated.' }
        format.json { render 'users/timeline', status: :ok, location: session.delete(:return_to) }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @post
    @post.destroy
    respond_to do |format|
      format.html { redirect_to session.delete(:return_to), notice: "Post '#{truncate(@post.body, length: 25)}' was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:body)
    end
end
