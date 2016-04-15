class Admin::PositionsController < AdminController

  # GET /admin/positions
  # GET /admin/positions.json
  def index
    @positions = Position.includes(:roles).all
  end

  # GET /admin/positions/1
  # GET /admin/positions/1.json
  def show
    @position = Position.find(params[:id])
  end

  # GET /admin/positions/new
  def new
    @admin_position = Position.new
  end

  # GET /admin/positions/1/edit
  def edit
    #@admin_position = Position.find(params[:id])
    @position = Position.find(params[:id])
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
    @position = Position.find(params[:id])
    if @position.update_attributes admin_position_params
      flash[:notice] = 'Position item has been updated'
      redirect_to admin_position_path(@position)
    else
      flash.now[:warning] = 'There were problems when trying to update this Position item'
      render :action => :show
    end
  end

  # DELETE /admin/positions/1
  # DELETE /admin/positions/1.json
  def destroy
    @admin_position = Position.find(params[:id])
    @admin_position.destroy
    @admin_position.destroy
    flash[:notice] = 'Position item has been deleted'
    redirect_to admin_positions_path
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
