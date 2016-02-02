class MediaController < ApplicationController

  #custom controller gives back all stuff in media section
  def index

    #publications #videos #exhibitions
    media = Project.includes(:section, :project_types, :primary_image).select{|p| p.section && p.section.title=="Media"}
    
    #bibliography
    bibs = BibliographyItem.includes(:primary_image)

    @items = media + bibs

    #joined and sent over
  end
end
