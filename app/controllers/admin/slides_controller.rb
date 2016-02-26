class Admin::SlidesController < AdminController
  def index
    @title = "Slide"
    @section_id = params[:type] || Section.find_by_title("Home Page").id.to_s
    @sections = Section.all.select{|s| !s.slides.empty? }.sort_by{|sec| sec.rank || 999 }

    @slides = Slide.includes(:section).where(nil)
    @slides = @slides.with_section(@section_id) if @section_id
    @slides = @slides.sort_by{|sl|sl.rank || 999}
  end

  def show
    @slide = Slide.includes(:section).find params[:id]
  end

  def new
    @slide = Slide.new
  end

  def create
    @slide = Slide.new slide_params
    if @slide.save
      flash[:notice] = 'Slide created'
      redirect_to admin_slides_path
    else
      flash.now[:warning] = 'There were problems when trying to create a new slide'
      render action: :new
    end
  end

  def update
    @slide = Slide.find params[:id]

    if @slide.update_attributes slide_params
      flash[:notice] = 'Slide has been updated'
      #redirect_to admin_slides_path
      redirect_to :back
    else
      flash.now[:warning] = 'There were problems when trying to update this slide'
      render :action => :show
    end
  end

  def destroy
    @slide = Slide.find params[:id]

    @slide.destroy
    flash[:notice] = 'Slide has been deleted'
    redirect_to admin_slides_path
  end

  def rank
    pp = params[:slides]
    if Slide.update(pp.keys, pp.values)
      flash[:notice] = 'Type items have been updated'
    else
      flash[:notice] = 'Problems'
    end
    redirect_to admin_slides_path
  end

  private

  def slide_params
    params.require(:slide).permit(
      :id,
      :title,
      :section_id,
      :project_id,
      mp4_attributes: [
        :id,
        :title,
        :name
      ],
      image_attributes: [
        :id,
        :title,
        :name
      ],
      webm_attributes: [
        :id,
        :title,
        :name
      ],
      gif_attributes: [
        :id,
        :title,
        :name
      ]
    )
  end

  private
end
