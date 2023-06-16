class DocsController < ApplicationController
  before_action :set_doc, only: %i[ show edit update destroy mark_current ]
  include ActiveStorage::SetCurrent
  CURRENT_IMAGE_DOC_TYPE = "Current-Image"

  # GET /docs or /docs.json
  def index
    @docs = Doc.all
  end

  # GET /docs/1 or /docs/1.json
  def show
  end

  # GET /docs/new
  def new
    @doc = Doc.new
  end

  # GET /docs/1/edit
  def edit
  end

  def mark_current
    @word = Word.find(@doc.documentable_id)
    @word.docs.update_all(doc_type: "")

    respond_to do |format|
      if @doc.update(doc_type: CURRENT_IMAGE_DOC_TYPE)
        format.html { redirect_to @word }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render @word, status: :unprocessable_entity }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /docs or /docs.json
  def create
    @doc = Doc.create(doc_params)
    path_to_pdf = @doc.main_image_on_disk
    puts "path_to_pdf: #{path_to_pdf}"
    document = Poppler::Document.new(path_to_pdf)

    raw_content = document.map { |page| page.get_text }.join
    body_content = raw_content.split("")
    @doc.raw_body = raw_content
    @doc.body = body_content.join("<br>")

    respond_to do |format|
      if @doc.save
        format.html { redirect_to doc_url(@doc), notice: "Doc was successfully created." }
        format.json { render :show, status: :created, location: @doc }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /docs/1 or /docs/1.json
  def update
    respond_to do |format|
      if @doc.update(doc_params)
        format.html { redirect_to doc_url(@doc), notice: "Doc was successfully updated." }
        format.json { render :show, status: :ok, location: @doc }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @doc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /docs/1 or /docs/1.json
  def destroy
    @doc.destroy!

    respond_to do |format|
      format.html { redirect_to docs_url, notice: "Doc was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doc
    @doc = Doc.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def doc_params
    params.require(:doc).permit(:name, :doc_type, :main_image)
  end
end
