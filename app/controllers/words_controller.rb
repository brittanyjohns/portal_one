class WordsController < ApplicationController
  before_action :set_word, only: %i[ show edit update destroy speak generate_image generate_image_variation ]

  # GET /words or /words.json
  def index
    @words = Word.includes(:docs).order(name: :desc)
  end

  def speak
    @word.speak
    # respond_to do |format|
    #   if @word.speak
    #     format.turbo_stream
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #   end
    # end
  end

  def generate_image
    puts "About to resubmit"
    resubmit(@word)
    puts "WORD::: #{@word.inspect}"
  end

  def generate_image_variation
    respond_to do |format|
      if @word.create_image_variation
        format.html { redirect_to @word, notice: "Word was successfully created." }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render @word, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /words/1 or /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words or /words.json
  def create
    puts "", "CREATE: "
    pp word_params.inspect
    @word = Word.find_or_create_by(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to word_url(@word), notice: "Word was successfully created." }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1 or /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to word_url(@word), notice: "Word was successfully updated." }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1 or /words/1.json
  def destroy
    @word.destroy!

    respond_to do |format|
      format.html { redirect_to words_url, notice: "Word was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = Word.includes(:docs).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def word_params
    params.require(:word).permit(:name, :category_id, :favorite, :picture_description, :send_request_on_save, docs_attributes: [:_destroy, :id, :name, :doc_type, :main_image])
  end
end
