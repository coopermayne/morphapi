class MenuController < ApplicationController
  def links
  end

  def index
    render json: Rails.cache.fetch('menu', :expires_in => 30.days){
      get_menu.to_json
    }
  end

	def videos
    render json: Rails.cache.fetch('videos', :expires_in => 30.days){
      Section.find_by_title("Home Page").get_slides.to_json
    }
	end

end


def get_menu
    all_slides = Slide.get_all_slides
      
    news = NewsItem.news_box_items     



    morph_slides = all_slides["Morphosis"]
    arch_slides = all_slides["Architecture"]
    research_slides = all_slides["Research"]
    planning_slides = all_slides["Planning"]
    tan_slides = all_slides["Tangents"]

    res = {}
    morph_section = Section.find_by_title( "Morphosis" )
    res[:sections] = [
      {
      title: 'Morphosis',
      slides: morph_slides,
      url: "about",
      contact: morph_section.pcontact,
      about: morph_section.pabout,
      employment: morph_section.pemployment,
      media: morph_section.pmedia,
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
      slides: arch_slides,
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
      slides: planning_slides,
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
      slides: tan_slides,
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
      slides: research_slides,
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
    res
end
