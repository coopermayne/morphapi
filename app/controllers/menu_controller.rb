class MenuController < ApplicationController
  def links
  end

  def index

    news = NewsItem.news_box_items     
    morph_slides = Section.find_by_title("Morphosis").get_slides
    arch_slides = Section.find_by_title("Architecture").get_slides
    research_slides = Section.find_by_title("Research").get_slides
    urban_slides = Section.find_by_title("Urban").get_slides
    tan_slides = Section.find_by_title("Tangents").get_slides
    morph_slides = Section.find_by_title("Morphosis").get_slides
    vid_slides = Section.find_by_title("Home Page").get_slides

    res = {}
    res[:landing] = {
			slides: vid_slides
    }

    res[:sections] = [
      {
      title: 'Morphosis',
      slides: morph_slides,
      url: "about",
      content: Section.find_by_title( "Morphosis" ).content,
      sorting: [ {
        title: 'Awards',
        items: ''
      }, {
        title: 'People',
        items: ''
      }, {
        title: 'Media',
        items: ['Publications', 'Bibliography', 'Videos']
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
        items: ['America', 'Europe', 'Asia']
      } ]
    }, 
    
    {
      title: 'Urban',
      slides: urban_slides,
      url: "urban",
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
    render json: res
  end

	def videos
    vid_slides = Section.find_by_title("Home Page").get_slides
		render json: vid_slides
	end

end


