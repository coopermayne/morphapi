class Admin::PositionsController < AdminController

  # GET /admin/positions
  # GET /admin/positions.json
  def index
    @positions = Position.includes(:roles).all
  end

  # GET /admin/positions/1
  # GET /admin/positions/1.json
  def show
  end

  # GET /admin/positions/new
  def new
    @admin_position = Position.new
  end

  # GET /admin/positions/1/edit
  def edit
  end

  # POST /admin/positions
  # POST /admin/positions.json
  def create
    @admin_position = Position.new(admin_position_params)

    respond_to do |format|
      if @admin_position.save
        format.html { redirect_to admin_positions_path, notice: 'Position was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /admin/positions/1
  # PATCH/PUT /admin/positions/1.json
  def update
    respond_to do |format|
      if @admin_position.update(admin_position_params)
        format.html { redirect_to @admin_position, notice: 'Position was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_position }
      else
        format.html { render :edit }
        format.json { render json: @admin_position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/positions/1
  # DELETE /admin/positions/1.json
  def destroy
    @admin_position.destroy
    respond_to do |format|
      format.html { redirect_to admin_positions_url, notice: 'Position was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin_position
      @admin_position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_position_params
      params.require(:position).permit(:title, :rank)
    end
end
