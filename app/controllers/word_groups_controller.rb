class WordGroupsController < ApplicationController
  before_action :set_word_group, only: %i[ show edit update destroy ]

  # GET /word_groups or /word_groups.json
  def index
    @groups = Group.all
    @word_groups = WordGroup.all
  end

  # GET /word_groups/1 or /word_groups/1.json
  def show
  end

  # GET /word_groups/new
  def new
    @words = Word.take(10)
    @word_group = WordGroup.new
  end

  # GET /word_groups/1/edit
  def edit
  end

  # POST /word_groups or /word_groups.json
  def create
    @word_group = WordGroup.new(word_group_params)

    respond_to do |format|
      if @word_group.save
        format.html { redirect_to word_group_url(@word_group), notice: "Word group was successfully created." }
        format.json { render :show, status: :created, location: @word_group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @word_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /word_groups/1 or /word_groups/1.json
  def update
    respond_to do |format|
      if @word_group.update(word_group_params)
        format.html { redirect_to word_group_url(@word_group), notice: "Word group was successfully updated." }
        format.json { render :show, status: :ok, location: @word_group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @word_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /word_groups/1 or /word_groups/1.json
  def destroy
    @word_group.destroy!

    respond_to do |format|
      format.html { redirect_to word_groups_url, notice: "Word group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_word_group
    @word_group = WordGroup.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def word_group_params
    params.require(:word_group).permit(:group_id, :user_id, :word_id)
  end
end
