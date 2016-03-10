class MediaController < ApplicationController

  #custom controller gives back all stuff in media section
  def index
    page = params[:p] #(nil or a number)
    type = params[:q] #(publications/bibliography/videos)
    sorting = params[:sub] #(pub_date)/(title)

    #set page vars
    per_page = 30
    starting_page = page ? 30*page.to_i : 0

    media = nil
    bibs = nil

    if type == "publications"
      
      #publications #videos
      media = Project.includes(:uploads, :section, :project_types, :primary_image).select{|p| p.section && p.section.title=="Publications"}
      
    elsif type == "bibliography"

      #bibliography
      bibs = BibliographyItem.includes(:uploads, :primary_image)

    elsif type == "videos"
      #
      #publications #videos
      media = Project.includes(:uploads, :section, :project_types, :primary_image).select{|p| p.section && p.section.title=="Videos"  }

    else
      #publications #videos
      media = Project.includes(:uploads, :section, :project_types, :primary_image).select{|p| p.section && (p.section.title=="Publications" || p.section.title=="Videos"  )}

      #bibliography
      bibs = BibliographyItem.includes(:uploads, :primary_image)

      @items = media + bibs
    end

    @items = []
    @items += media if media
    @items += bibs if bibs
    @items = @items.select{|i| !i.title.blank? }

    #sorting
    if params[:sub] == 'title'
      @items = @items.sort_by{|i| i.title.strip.downcase }
    else
      @items.sort_by!{|i| i.date || Time.parse("20-08-1000") }.reverse!
    end
    
    #paginating
    @items = @items.slice(starting_page, per_page)
  end
end
