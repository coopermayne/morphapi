class MediaController < ApplicationController

  #custom controller gives back all stuff in media section
  def index

    #publications #videos
    media = Project.includes(:section, :project_types, :primary_image).select{|p| p.section && (p.section.title=="Publications" || p.section.title=="Videos"  )}
    
    #bibliography
    bibs = BibliographyItem.includes(:primary_image)

    @items = media + bibs
  end
end
