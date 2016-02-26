class MenuController < ApplicationController
  def links
  end

  def index

    news = NewsItem.where.not(primary_image: nil).order(created_at: :desc).limit(10).map do |item|
      img = item.primary_image ? item.primary_image.name : nil
      {id: item.id, title: item.title, image: img }
    end

    arch_slides = Section.includes(slides: [:image, :project]).find_by_title("Architecture").slides.map do |slide|
      {
        project_id: slide.project.id,
        project_title: slide.project.title,
        image: slide.image.name
      }
    end

    urban_slides = Section.includes(slides: [:image, :project]).find_by_title("Urban").slides.map do |slide|
      {
        project_id: slide.project.id,
        project_title: slide.project.title,
        image: slide.image.name
      }
    end
    tan_slides = Section.includes(slides: [:image, :project]).find_by_title("Tangents").slides.map do |slide|
      {
        project_id: slide.project.id,
        project_title: slide.project.title,
        image: slide.image.name
      }
    end
    morph_slides = Section.includes(slides: [:image, :project]).find_by_title("Morphosis").slides.map do |slide|
      {
        image: slide.image.name
      }
    end

    vid_slides = Section.includes(slides: [:image, :project]).find_by_title("Home Page").slides.map do |slide|
      {
        mp4: slide.mp4.name,
        webm: slide.webm.name,
        gif: slide.gif.name,
        image: slide.image.name
      }
    end

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
        items: ['Publications', 'Bibliography', 'Video']
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
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019' ]
      }, {
        title: 'Type',
        items: Section.find_by_title("Architecture").get_types
      }, {
        title: 'Location',
        items: []
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
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019' ]
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
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019' ]
      }, {
        title: 'Type',
        items: Section.find_by_title("Tangents").get_types
      } ]
    }, {
      title: 'Research',
      slides: arch_slides,
      url: 'research',
      sorting: [{
          #title: "Now Institute",
          #items: types["Research"]
      }]
    }, {
      title: 'News',
      url: 'news',
      items: news
    }
    ]
    render json: res
  end

end


