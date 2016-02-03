class MenuController < ApplicationController
  #def index
    #@sections = Section.all.select{|s| s.rank}.sort_by{|s| s.rank}
  #end
  def links

  end

  def index

    types = Hash.new []

    Project.includes(:project_types, :section).each do |p|
      next if !p.section
      types[p.section.title] =  (types[p.section.title] + p.project_types.map(&:title)).uniq
    end
    
    arch_slides = Section.includes(slides: [:image, :project]).find_by_title("Architecture").slides.map do |slide|

      {
        project_id: slide.project.id,
        project_title: slide.project.title,
        image: slide.image.name
      }
    end

    res = [
      {
      title: 'Morphosis',
      url: "",
      sorting: [ {
        title: 'Awards',
        items: ''
      }, {
        title: 'People',
        items: ''
      }, {
        title: 'Media',
        items: ['Publications', 'Bibliography', 'Exhibitions', 'Video']
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
        items: types["Architecture"]
      }, {
        title: 'Location',
        items: []
      } ]
    }, 
    
    {
      title: 'Urban',
      url: "urban",
      sorting: [ {
        title: 'A-Z',
        items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      }, {
        title: 'Year',
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019' ]
      }, {
        title: 'Type',
        items: types["Urban"]
      }, {
        title: 'Location',
        items: []
      } ]
    }, 
    
    {
      title: 'Tangents',
      url: "tangents",
      sorting: [ {
        title: 'A-Z',
        items: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      }, {
        title: 'Year',
        items: [ '1970-1979', '1980-1989', '1990-1999', '2000-2009', '2010-2019' ]
      }, {
        title: 'Type',
        items: types["Tangents"]
      } ]
    }, {
      title: 'Research',
      url: 'research'
    }, {
      title: 'News',
      url: 'news'
    },{
      title: "Search",
      url: "search"
    }
    ]

    render json: res
  end

end
