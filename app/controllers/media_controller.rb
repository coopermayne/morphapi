class MediaController < ApplicationController

  #custom controller gives back all stuff in media section
  def index

    #bibliography
    
    #publications
    #videos
    #exhibitions
    @media = Project.all
  end
end
