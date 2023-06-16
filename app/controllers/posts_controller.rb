class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  include ActiveStorage::SetCurrent

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @post.send_request_on_save = true
    @message = @post.messages.new
  end

  # GET /posts/new
  def new
    @show_docs = false
    @post = Post.new
    @doc = @post.docs.new
    @message = @post.messages.new
  end

  # GET /posts/1/edit
  def edit
    @doc = @post.docs.new
    @message = @post.messages.new
  end

  # POST /posts or /posts.json
  def create
    puts "\n\nparams: #{params.inspect}\n\n"
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    check_doc_image
    check_chat_messages
    params.require(:post).permit(:name, :body, :send_request_on_save, :response_type,
                                 docs_attributes: [:_destroy, :id, :name, :doc_type, :main_image],
                                 messages_attributes: [:_destroy, :id, :role, :content])
  end

  def check_doc_image
    docs_attributes = params["post"]["docs_attributes"]
    puts "docs_attributes: #{docs_attributes}"
    if docs_attributes
      docs_attributes.each_value do |doc|
        main_image = doc["main_image"]
        if main_image
          puts "#{main_image.class} saving main_image\n#{main_image.inspect}"
        else
          puts "no main_image"
          params["post"].delete("docs_attributes")
          puts "new params #{params}"
        end
      end
    else
      puts "no docs to save"
    end
  end

  def check_chat_messages
    messages_attributes = params["post"]["messages_attributes"]
    puts "messages_attributes: #{messages_attributes}"
    if messages_attributes
      messages_attributes.each_pair do |key, val|
        role = val["role"]
        if role.empty?
          params["post"]["messages_attributes"].delete(key)
        end
      end
    else
      puts "no messages to save"
    end
  end
end
