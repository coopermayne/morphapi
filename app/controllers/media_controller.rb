class MediaController < ApplicationController

  #custom controller gives back all stuff in media section
  def index

    #get params
    page = params[:p] #(nil or a number)
    type = params[:q] #(books/bibliography/videos)
    sorting = params[:sub] #(pub_date)/(title)
    
    #set page vars
    per_page = 30
    starting_page = page ? 30*page.to_i : 0

    render json: Rails.cache.fetch("media#{page}#{type}#{sorting}", :expires_in => 30.days){

      media = nil
      bibs = nil
      @awards = nil
      @exhibitions = nil

      if type == "books"
        
        #books #videos
        media = Project.includes(:uploads, :section, :project_types, :primary_image).select{|p| p.section && p.section.title=="Books"}
        
      elsif type == "bibliography"

        #bibliography
        bibs = BibliographyItem.includes(:uploads, :primary_image)

      elsif type == "awards"
        @awards = Award.where.not(:year => nil).includes(:primary_image, :projects).order(year: :desc)

      elsif type == "exhibitions"
        @exhibitions = NewsType.find_by_title("Exhibitions").news_items

      elsif type == "videos"
        #
        #books #videos
        media = Project.includes(:uploads, :section, :project_types, :primary_image).select{|p| p.section && p.section.title=="Videos"  }

      else
        #books #videos
        media = Project.includes(:uploads, :section, :project_types, :primary_image).select{|p| p.section && (p.section.title=="Books" || p.section.title=="Videos"  )}

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
      if @awards
        @total_pages = ( @awards.count/30 ).ceil
        @current_page = page || 0
        @awards = @awards.slice(starting_page, per_page)
      elsif @exhibitions
        @total_pages = ( @exhibitions.count/30 ).ceil
        @current_page = page || 0
        @exhibitions = @exhibitions.slice(starting_page, per_page)
      else
        @total_pages = ( @items.count/30 ).ceil
        @current_page = page || 0
        @items = @items.slice(starting_page, per_page)
      end

      render_to_string :index
    }

  end
end
