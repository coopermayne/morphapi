class Admin::SlidesController < AdminController
  def index
    @title = "Slides"
    @section_id = params[:type] || Section.find_by_title("Home Page").id.to_s
    @sections = Section.all.select{|s| s.rank }.sort_by{|sec| sec.rank }

    @slides = Slide.includes(:section).where(nil)
    @slides = @slides.with_section(@section_id) if @section_id
    @slides = @slides.sort_by{|sl|sl.rank || 999}

    if Section.find_by_title("Morphosis").id == params[:type].to_i
      @morph_section = Section.find_by_title("Morphosis")
    end
  end

  def show
    @title = "Edit Slide"
    @slide = Slide.includes(:section).find params[:id]
  end

  def new
    @title = "New Slide"
    @slide = Slide.new
  end

  def create
    @slide = Slide.new slide_params
    if @slide.save
      flash[:notice] = 'Slide created'
      redirect_to admin_slides_path
    else
      #flash.now[:warning] = 'There were problems when trying to create a new slide'
      flash[:error] = @slide.errors.empty? ? "Error" : @slide.errors.full_messages.to_sentence
      render action: :new
    end
  end

  def update
    @slide = Slide.find params[:id]

    if @slide.update_attributes slide_params
      flash[:notice] = 'Slide has been updated'
      #redirect_to admin_slides_path
      redirect_to admin_slide_path(@slide)
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
		about_params = params[:section]
    slides_params = params[:slides]

    res1 = true
    if about_params
      s = Section.find(about_params[:id])

      s.contact = about_params[:contact]
      s.about = about_params[:about]
      s.employment = about_params[:employment]

      res1 = s.save
    end

		res2 = Slide.update(slides_params.keys, slides_params.values)

    if res1 && res2
      flash[:notice] = 'Type items have been updated'
    else
      flash[:notice] = 'Problems'
    end

    redirect_to :back
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
