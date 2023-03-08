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
    morph_section = Section.find_by_title( "Morphosis" )

    res = {}
    res[:sections] = [
      {
      title: 'Morphosis',
      slides: all_slides["Morphosis"],
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
        items: ['Partners', 'Leadership']
      }, {
        title: 'Media',
        items: ['Books', 'Bibliography', 'Awards']
      } ]
    },

    {
      title: 'Architecture',
      slides: all_slides["Architecture"],
      url: "architecture",
      sorting: [ {
        title: 'A-Z',
        items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      }, {
        title: 'Year',
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019','2020-2029' ].reverse
      }, {
        title: 'Type',
        items: Section.find_by_title("Architecture").get_types
      } ]
    },

    {
      title: 'Planning',
      slides: all_slides["Planning"],
      url: "planning",
      sorting: [ {
        title: 'A-Z',
        items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      }, {
        title: 'Year',
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019','2020-2029' ].reverse
      } ]
    },

    {
      title: 'Tangents',
      slides: all_slides["Tangents"],
      url: "tangents",
      sorting: [ {
        title: 'A-Z',
        items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      }, {
        title: 'Year',
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019','2020-2029' ].reverse
      }, {
        title: 'Type',
        items: Section.find_by_title("Tangents").get_types
      } ]
    }, {
      title: 'Research',
      slides: all_slides["Research"],
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
