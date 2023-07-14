class GalleriesController < ApplicationController
  before_action :set_gallery, :set_image_type, :set_image_type_text, only: %i[ show edit update destroy generate_image generate_image_variation generate_random_prompt ]

  # GET /galleries or /galleries.json
  def index
    @galleries = @current_user.galleries.all
  end

  # GET /galleries/1 or /galleries/1.json
  def show
    @gallery.image_prompt = @gallery.main_doc&.name || @gallery.random_prompt
    @docs = @gallery.docs.where.not(id: @gallery.main_doc).order(created_at: :desc)
    puts "****\n****\ndocs: #{@docs.first&.id}\n***"
  end

  def generate_random_prompt
    @gallery.image_prompt = @gallery.random_prompt
    puts "Rendering show"
    render :show
  end

  def generate_image
    puts "params: #{params}\ngallery_params['image_prompt']:#{gallery_params["image_prompt"]}"
    puts "About to resubmit"
    image_prompt = @scrubbed + " #{@image_type_text.downcase}"
    puts "", "image_prompt:", image_prompt
    @gallery.image_prompt = image_prompt
    resubmit(@gallery)
  end

  def generate_image_variation
    respond_to do |format|
      if @gallery.create_image_variation
        format.html { redirect_to @gallery }
        format.json { render :show, status: :created, location: @gallery }
      else
        format.html { render @gallery, status: :unprocessable_entity }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  def scrub_current_prompt
    image_prompt_text = gallery_params["image_prompt"] || @gallery.image_prompt || params["image_prompt"]
    puts "image_prompt_text: #{image_prompt_text}"
    @scrubbed = @gallery.remove_extras_from_prompt(image_prompt_text)
    puts "scrubbed:", @scrubbed
  end

  def set_image_type
    puts "params #{params.inspect}"
    @image_type = gallery_params["image_type"]
    scrub_current_prompt
  end

  def set_image_type_text
    puts "@image_type: #{@image_type}"
    case @image_type
    when "Cover Letter"
      @image_type_text = "Write a cover letter for a senior software engineer position using the following resume"
    when "Estimate Salary"
      @image_type_text = "Estimate the annual salary based on the following work experience"
    when "Estimate Pay"
      @image_type_text = "Estimate the annual salary based on the following job posting"
    when "None"
      @image_type_text = ""
    when "About"
      @image_type_text = "Rewrite the About section of this LinkedIn profile"
    when "Summary"
      @image_type_text = "Write a professional summary using the work experience in this LinkedIn profile"
    else
      @image_type_text = @image_type || ""
    end
  end

  # GET /galleries/new
  def new
    @gallery = Gallery.new
    @gallery.user = @current_user || User.first
  end

  # GET /galleries/1/edit
  def edit
  end

  # POST /galleries or /galleries.json
  def create
    @gallery = Gallery.new(name: gallery_params["name"])
    @gallery.user = @current_user || User.first

    respond_to do |format|
      if @gallery.save
        format.html { redirect_to gallery_url(@gallery), notice: "Gallery was successfully created." }
        format.json { render :show, status: :created, location: @gallery }
      else
        puts "@gallery.errors: #{@gallery.errors}"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /galleries/1 or /galleries/1.json
  def update
    respond_to do |format|
      if @gallery.update(gallery_params)
        format.html { redirect_to gallery_url(@gallery), notice: "Gallery was successfully updated." }
        format.json { render :show, status: :ok, location: @gallery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1 or /galleries/1.json
  def destroy
    @gallery.destroy!

    respond_to do |format|
      format.html { redirect_to galleries_url, notice: "Gallery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_gallery
    @gallery = Gallery.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def gallery_params
    # params.require(:gallery).permit(:user_id, :name, :state, :image_prompt, :send_request_on_save)
    params[:gallery] || {}
  end
end
