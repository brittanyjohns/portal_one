class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy create_word select_words ]

  # GET /groups or /groups.json
  def index
    puts "@current_user:#{@current_user.class} #{@current_user.inspect}"
    @groups = @current_user.groups.all
  end

  # GET /groups/1 or /groups/1.json
  def show
    @words = @group.words
    @word = @group.words.new
  end

  def create_word
    puts "", "CREATE: "
    puts "PARAMS: #{params}"
    word_params = params["word"]
    puts "", "word_params:", word_params

    @word = Word.find(name: word_params["name"])
    unless @word
      @word = Word.find_or_create_by(name: word_params["name"], category_id: Category.uncategorized_id)
    end
    word_group = WordGroup.new(group_id: @group.id, word_id: @word.id)
    # @group.word_ids << @word.id

    respond_to do |format|
      if word_group.save
        format.html { redirect_to group_url(@group), notice: "Word was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def select_words
    puts "PARAMS: #{params}"
    wors_list = params["group"]["word_ids"]
    # puts "wors_list: #{wors_list.compact_blank}"
    # @group.attributes = { "word_ids" => [] }.merge(params[:group] || {})
    @group.word_ids = wors_list
    # @word = Word.find(params["word_id"])
    # @word.speak
    # @group.word_groups.find_or_create_by!(word_id: @word.id)

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_url(@group) }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def select_word
    puts "PARAMS: #{params}"
    pp params
    @word = Word.find(params["word_id"])
    @word.speak
    @group.word_groups.find_or_create_by!(word_id: @word.id)

    # respond_to do |format|
    #   if @group.save
    #     format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
    #     format.json { render :show, status: :created, location: @group }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @group.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @words = Word.last(5)
  end

  # POST /groups or /groups.json
  def create
    @group = Group.new(group_params)
    @group.user = @current_user

    respond_to do |format|
      if @group.save
        format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy!

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.includes(:words, :word_groups).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def group_params
    params.require(:group).permit(:name, word_ids: [])
  end
end
