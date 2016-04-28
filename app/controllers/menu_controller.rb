class MenuController < ApplicationController
  def links
  end

  def index

    news = NewsItem.news_box_items     
    #morph_slides = Section.find_by_title("Morphosis").get_slides
    #arch_slides = Section.find_by_title("Architecture").get_slides
    #research_slides = Section.find_by_title("Research").get_slides
    #planning_slides = Section.find_by_title("Planning").get_slides
    #tan_slides = Section.find_by_title("Tangents").get_slides
    #vid_slides = Section.find_by_title("Home Page").get_slides
    #@projects = Project.includes(:primary_image, :project_types, :section, :components)

    res = {}
    res[:landing] = {
			slides: vid_slides
    }

    res[:sections] = [
      {
      title: 'Morphosis',
      slides: [],
      url: "about",
      contact: Section.find_by_title( "Morphosis" ).pcontact,
      about: Section.find_by_title( "Morphosis" ).pabout,
      employment: Section.find_by_title( "Morphosis" ).pemployment,
      media: Section.find_by_title( "Morphosis" ).pmedia,
      sorting: [ {
        title: 'Contact',
        items: ''
      }, {
        title: 'People',
        items: ['Leadership']
      }, {
        title: 'Media',
        items: ['Books', 'Bibliography', 'Awards']
        #items: ['Books', 'Bibliography', 'Videos', 'Awards', 'Exhibitions']
      } ]
    },

    {
      title: 'Architecture',
      slides: [],
      url: "architecture",
      sorting: [ {
        title: 'A-Z',
        items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      }, {
        title: 'Year',
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019' ].reverse
      }, {
        title: 'Type',
        items: Section.find_by_title("Architecture").get_types
      }, {
        title: 'Location',
        items: []
      } ]
    }, 
    
    {
      title: 'Planning',
      slides: [],
      url: "planning",
      sorting: [ {
        title: 'A-Z',
        items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      }, {
        title: 'Year',
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019' ].reverse
      }, {
        title: 'Location',
        items: []
      } ]
    }, 
    
    {
      title: 'Tangents',
      slides: [],
      url: "tangents",
      sorting: [ {
        title: 'A-Z',
        items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      }, {
        title: 'Year',
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019' ].reverse
      }, {
        title: 'Type',
        items: Section.find_by_title("Tangents").get_types
      } ]
    }, {
      title: 'Research',
      slides: [],
      url: 'research',
      sorting: [{
          title: "Now Institute",
          items: []
      }]
    }, {
      title: 'News',
      url: 'news',
      items: news
    }
    ]
    render json: res
  end

	def videos
    vid_slides = Section.find_by_title("Home Page").get_slides
		render json: vid_slides
	end

end


