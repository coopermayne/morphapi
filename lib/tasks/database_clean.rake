# lib/tasks/custom_seed.rake
namespace :db do

  task sub_images: :environment do
    Component.all.select{|c| c.content.match("{file}")}.each do |comp|
      r = /{file}(\d*)\|.+?{\/file}/
      cc = comp.content

      def doIt(mat)
        the_source = Upload.find_by_old_id mat
        if the_source
          "<img src='" + the_source.name.mobile.url + "'></img" 
        else
          ""
        end
      end

      comp.content = cc.gsub(r){ doIt(Regexp.last_match[1]) }
      comp.save
    end
  end

	task clean_component_text: :environment do
		Component.all.each do |comp|
			method = :content
			comp.send(method).gsub!(/\\r\\n/,"") 
			comp.send(method).gsub!("{break}","") 
			comp.save
		end
	end

	task add_titles_to_components: :environment do
		Component.all.each do |comp|
			comp.title = comp.component_type.title
			comp.save
		end
	end

  task seed_index_image_id: :environment do
    [Project, Award, BibliographyItem, Person, NewsItem].each do |model|
      model.all.each do |instance|
        if instance.primary_image
          instance.index_image = instance.primary_image
          instance.save
        end
      end
    end
  end

  task clean_content: :environment do
    c = 0
    [Component, Section, Award, BibliographyItem, NewsItem, Person, Project].each do |model|
      model.all.each do |instance|
        [:title, :overview, :description, :program, :content].each do |method|
          if instance.respond_to?(method) && !instance.send(method).nil?
            #puts instance.send(method).gsub!(/\\r\\n/,"") 
            #puts instance.send(method).gsub!("{break}","") 
            #c += 1 if instance.send(method).match("{file}") 
            #instance.save
          end
        end
      end
    end
    puts c
  end

  task format_galleries: :environment do
    #set in_gallery true to the images that are currently being displayed on morphopedia...
    featured = Upload.all.select{|u| u.is_featured}
    init_count = featured.count
    i = 0

    featured.each do |uf|
      p = uf.uploadable
      t = uf.file_type
      uf.in_gallery = true

      puts i += 1
      puts uf.save


      next if !p
      p.uploads.select{|u| u.file_type === t}.each do |u| 
        u.in_gallery = true

        puts i += 1
        puts u.save
      end
    end

    puts
    puts '----------------------------------------'
    puts Upload.all.select{|u| u.in_gallery}.count
  end

  task correct_types: :environment do
    ProjectType.all.each{|pt| pt.destroy if pt.title[0]=='x'}

    Project.all.select{|pr| pr.section}.each do |pr|
      new_root_type_name = 'x' + pr.section.title
      pt = ProjectType.find_or_create_by(title: new_root_type_name)

      pr.project_types.each do |project_type|
        ptt = 'x' + project_type.title
        sub = ProjectType.find_or_create_by(title: ptt)
        sub.parent = pt
        pr.project_types << sub
        pr.save
        sub.save
        puts pr.id
      end
    end

    ProjectType.all.each{|pt| pt.destroy if pt.title[0]!='x'}
    ProjectType.all.each do |pt|
      pt.title[0] ="" if pt.title[0]=='x'
      pt.save
    end
  end

  task correct_types_again: :environment do
    Project.all.each do |pr|
      pr.project_types.each do |pt|
        pt.section = pr.section
        puts pt.section.title
        puts pr.section.title
      end
    end
  end

  task data_entry_types: :environment do
    bad_names = {
      "Commercial": [
        "7132 Hotel and Arrival",
        "72 Market Street",
        "Angeli",
        "ASE Design Center",
        "Azalea Springs Winery",
        "BMW Event and Delivery Center",
        "Burj Al Maydan",
        "Chiba Golf Club",
        "Clyde Frazier's",
        "Contempo Casuals",
        "Hamburger Stand",
        "Hanking Center Tower",
        "Kate Mantilini",
        "Kuala Lumpur Towers",
        "Leon Max Showroom",
        "Lut èce",
        "Phare Tower",
        "Politix",
        "Tsunami",
        "Vecta Showroom"
      ],
      "Office": [
        "American Business Center",
        "BankMed Headquarters II",
        "BMW Event and Delivery Center",
        "Burj Al Maydan",
        "Casablanca Finance City Tower",
        "ENI Headquarters",
        "European Central Bank",
        "FJC Communications",
        "Giant Interactive Group Headquarters",
        "Hanking Center Tower",
        "Higashi Azabu Office Building",
        "Hypo Alpe-Adria Bank",
        "Hypo Alpe-Adria Center",
        "London Docklands Tower",
        "Phare Tower",
        "Salick Administrative Offices",
        "SHR Perceptual Management",
        "Sun Tower"
      ],
      "Culture": [
        "101 Pedestrian Bridge",
        "Air Force Memorial",
        "Artspark Performing Arts Pavilion",
        "Berlin Wall Competition",
        "Children's Museum of Los Angeles",
        "Denver Art Museum",
        "Eli and Edythe Broad Art Museum at MSU",
        "Emery Performing Arts Center",
        "Graz Kunsthaus",
        "IFP West Film Center",
        "Junipero Serra Shrine",
        "Los Angeles County Museum of Art",
        "MTV Studios",
        "Museo del Prado",
        "Museum of Fine Arts, Houston",
        "Nara Convention Center",
        "New Orleans National Jazz Center",
        "Osaka Expo '90 Folly",
        "Centro Sports Center",
        "Perot Museum of Nature and Science",
        "Rensselear Electronic Media and Performing Arts Center",
        "Seoul Performing Arts Center",
        "Smithsonian Institution's Arts & Industries Building",
        "Taipei Performing Arts Center",
        "Tours Cultural Arts Center",
        "University of Chicago Center for Creative and Performing Arts",
        "Vietnam War Memorial",
        "Yuzen Vintage Car Museum"
      ],
      "Education and Health": [
        "Amerika-Gedenkbibliothek",
        "Bill & Melinda Gates Hall",
        "Bloomberg Center",
        "Cahill Center for Astronomy and Astrophysics",
        "Cedars-Sinai Comprehensive Cancer Center",
        "Cornell School of Architecture",
        "Cranbrook Academy Gatehouse",
        "Diamond Ranch High School",
        "Dr. Theodore Alexander Science Center School",
        "Emerson College Los Angeles",
        "International Elementary School",
        "King Abdullah Petroleum Studies and Research Center",
        "Perth Amboy High School",
        "Princeton Humanities Building",
        "Rockwell Collins",
        "Salick Healthcare Administrative Headquarters",
        "Sequoyah Educational And Research Center",
        "Lawrence Tech Taubman Complex",
        "University of Chicago Center for Creative and Performing Arts",
        "University of Cincinnati Student Recreation Center",
        "University of Toronto Graduate Housing"
      ],
      "Government": [
        "Alaska State Capitol",
        "Caltrans District 7 Headquarters",
        "Frankfurt Waste Management Facility",
        "Lifeguard Tower",
        "U.S. Embassy in London",
        "NOAA Satellite Operations Center",
        "San Francisco Federal Building",
        "San Sebastian Subway Station Prototype",
        "Vialia Vigo TGV Station",
        "Wayne L. Morse United States Courthouse"
      ],
      "Multi-family": [
        "Emerson College Los Angeles",
        "Herald Examiner Residential Tower",
        "La Floresta Housing",
        "Madrid Public Housing",
        "University of Cincinnati Undergraduate Housing",
        "University of Toronto Graduate Housing",
        "Wagramerstrasse Housing "
      ],
      "Private Residence": [
        "2-4-6-8 House",
        "Blades Residence",
        "Cohen Residence",
        "Crawford Residence",
        "Delmer Residence",
        "Flores Residence",
        "Landa Residence",
        "Lawrence Residence",
        "Mack Residence",
        "FLOAT House",
        "Malibu Residence",
        "Mexico House II",
        "Rockledge Residence",
        "Sedlack Residence",
        "Sixth Street Residence",
        "Venice III Residence",
        "Was House / Was Residence",
        "X Holm",
      ],
      "Installations": [
        "Continuities of the Incomplete, Centre Pompidou",
        "Copenhagen Competition (Hippocampus)",
        "Gallery MA",
        "Silent Collisions / Charleroi Danses / NAI Exhibit",
        "Snow Show",
        "Time Capsule",
        "Vecta Temporary Showroom 2",
        "Vecta Temporary Showroom No. 1",
        "Venice Biennale, Wunderkammer’s The Importance of Dialogue: Seven Public Spaces",
        "Walker Art Center "
      ]
    }

    include Amatch

    total = 0
    results = []

    bad_names.each do |arch_type, bad_project_names|
      pt = ProjectType.find_by_title arch_type

      bad_project_names.each do |bad_name|
        total += 1

        if Project.find_by_title(bad_name)
          prr = Project.find_by_title(bad_name)
          result = [prr.id, bad_name, nil, prr.title, pt]

          p = Project.find(result[0])
          p.project_types = []
          p.project_types << pt
          ap p.project_types
          p.save

          results << result
        else
          m = Jaro.new(bad_name)
          prs = Project.all.select{|pr| pr.section == Section.find_by_title("Architecture")}.map{|pr| [pr.id, pr.title]}
          result = prs.map{|pr| [pr[0], bad_name, m.match(pr[1]), pr[1], pt]}.sort_by{|pr| pr[2]}.last

          if result[2] > 0.8 && result[0] != 3322
            p = Project.find(result[0])
            p.project_types = []
            p.project_types << pt
            ap p.project_types
            p.save

          end

          results << result
        end
      end
    end

    ap results.select{|pr| !pr[2].nil? && pr[2] < 0.8}
  end

  task copy_types: :environment do
    data = [
      [
        557,
        [
          "Education and Health"
        ]
      ],
      [
        558,
        [
          "Residential",
          "Multi-family"
        ]
      ],
      [
        553,
        [
          "Government"
        ]
      ],
      [
        554,
        [
          "Office"
        ]
      ],
      [
        945,
        [
          "Office"
        ]
      ],
      [
        629,
        [
          "Government"
        ]
      ],
      [
        896,
        [
          "Residential",
          "Multi-family"
        ]
      ],
      [
        852,
        [
          "Education and Health"
        ]
      ],
      [
        563,
        [
          "Installations"
        ]
      ],
      [
        559,
        [
          "Residential",
          "Multi-family"
        ]
      ],
      [
        1462,
        [
          "Education and Health"
        ]
      ],
      [
        1466,
        [
          "Commercial"
        ]
      ],
      [
        1468,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        4809,
        [
          "Education and Health"
        ]
      ],
      [
        947,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        946,
        [
          "Commercial"
        ]
      ],
      [
        897,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        2342,
        [
          "Culture"
        ]
      ],
      [
        1472,
        [
          "Installations"
        ]
      ],
      [
        1470,
        [
          "Culture"
        ]
      ],
      [
        1535,
        [
          "Office"
        ]
      ],
      [
        1886,
        [
          "Education and Health"
        ]
      ],
      [
        2887,
        [
          "Culture"
        ]
      ],
      [
        4512,
        [
          "Education and Health"
        ]
      ],
      [
        3136,
        [
          "Commercial"
        ]
      ],
      [
        3106,
        [
          "Commercial"
        ]
      ],
      [
        3099,
        [
          "Office"
        ]
      ],
      [
        3112,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        3319,
        [
          "Commercial"
        ]
      ],
      [
        3315,
        [
          "Residential",
          "Multi-family"
        ]
      ],
      [
        3322,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        3320,
        [
          "Culture"
        ]
      ],
      [
        3317,
        [
          "Office"
        ]
      ],
      [
        4517,
        [
          "Culture"
        ]
      ],
      [
        5119,
        [
          "Education and Health"
        ]
      ],
      [
        4472,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        4570,
        [
          "Culture"
        ]
      ],
      [
        5130,
        [
          "Government"
        ]
      ],
      [
        5132,
        [
          "Residential"
        ]
      ],
      [
        4383,
        [
          "Education and Health"
        ]
      ],
      [
        4602,
        [
          "Culture"
        ]
      ],
      [
        4559,
        [
          "Culture"
        ]
      ],
      [
        5133,
        [
          "Culture"
        ]
      ],
      [
        5021,
        [
          "Education and Health"
        ]
      ],
      [
        4819,
        [
          "Commercial"
        ]
      ],
      [
        5287,
        [
          "Education and Health"
        ]
      ],
      [
        5068,
        [
          "Culture"
        ]
      ],
      [
        5077,
        [
          "Government"
        ]
      ],
      [
        5084,
        [
          "Installations"
        ]
      ],
      [
        5347,
        [
          "Culture"
        ]
      ],
      [
        5341,
        [
          "Culture"
        ]
      ],
      [
        5349,
        [
          "Education and Health"
        ]
      ],
      [
        5346,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        5340,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        5345,
        [
          "Installations"
        ]
      ],
      [
        5563,
        [
          "Installations"
        ]
      ],
      [
        6604,
        [
          "Education and Health"
        ]
      ],
      [
        6042,
        [
          "Culture"
        ]
      ],
      [
        5344,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        5564,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        7318,
        [
          "Government"
        ]
      ],
      [
        9640,
        [
          "Commercial"
        ]
      ],
      [
        8909,
        [
          "Education and Health"
        ]
      ],
      [
        8992,
        [
          "Office"
        ]
      ],
      [
        9075,
        [
          "Culture"
        ]
      ],
      [
        9165,
        [
          "Education and Health"
        ]
      ],
      [
        9776,
        [
          "Government"
        ]
      ],
      [
        560,
        [
          "Office"
        ]
      ],
      [
        1463,
        [
          "Commercial"
        ]
      ],
      [
        942,
        [
          "Culture"
        ]
      ],
      [
        1469,
        [
          "Education and Health"
        ]
      ],
      [
        5342,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        1521,
        [
          "Installations"
        ]
      ],
      [
        1526,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        2928,
        [
          "Office"
        ]
      ],
      [
        562,
        [
          "Government"
        ]
      ],
      [
        288,
        [
          "Office"
        ]
      ],
      [
        561,
        [
          "Education and Health"
        ]
      ],
      [
        3323,
        [
          "Government"
        ]
      ],
      [
        9021,
        [
          "Education and Health"
        ]
      ],
      [
        4375,
        [
          "Office"
        ]
      ],
      [
        4590,
        [
          "Culture"
        ]
      ],
      [
        4765,
        [
          "Education and Health"
        ]
      ],
      [
        5055,
        [
          "Culture"
        ]
      ],
      [
        5562,
        [
          "Commercial"
        ]
      ],
      [
        5085,
        [
          "Culture"
        ]
      ],
      [
        5083,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        5343,
        [
          "Culture"
        ]
      ],
      [
        5565,
        [
          "Culture"
        ]
      ],
      [
        3692,
        [
          "Commercial"
        ]
      ],
      [
        6443,
        [
          "Residential",
          "Multi-family"
        ]
      ],
      [
        9490,
        [
          "Culture"
        ]
      ],
      [
        9397,
        [
          "Office"
        ]
      ],
      [
        555,
        [
          "Education and Health"
        ]
      ],
      [
        6711,
        [
          "Government"
        ]
      ],
      [
        9712,
        [
          "Office"
        ]
      ],
      [
        944,
        [
          "Office"
        ]
      ],
      [
        1460,
        [
          "Commercial"
        ]
      ],
      [
        1484,
        [
          "Commercial"
        ]
      ],
      [
        1514,
        [
          "Commercial"
        ]
      ],
      [
        1537,
        [
          "Commercial"
        ]
      ],
      [
        2960,
        [
          "Culture"
        ]
      ],
      [
        4642,
        [
          "Culture"
        ]
      ],
      [
        4384,
        [
          "Culture"
        ]
      ],
      [
        4971,
        [
          "Culture"
        ]
      ],
      [
        5082,
        [
          "Office"
        ]
      ],
      [
        5136,
        [
          "Education and Health"
        ]
      ],
      [
        9314,
        [
          "Office"
        ]
      ],
      [
        8496,
        [
          "Commercial"
        ]
      ],
      [
        628,
        [
          "Government"
        ]
      ],
      [
        920,
        [
          "Residential"
        ]
      ],
      [
        948,
        [
          "Office"
        ]
      ],
      [
        3060,
        [
          "Residential",
          "Multi-family"
        ]
      ],
      [
        3325,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        3324,
        [
          "Residential",
          "Private Residence"
        ]
      ],
      [
        4529,
        [
          "Culture"
        ]
      ],
      [
        4620,
        [
          "Commercial"
        ]
      ],
      [
        4704,
        [
          "Office"
        ]
      ],
      [
        8982,
        [
          "Residential",
          "Multi-family"
        ]
      ],
      [
        3014,
        [
          "Culture"
        ]
      ],
      [
        9278,
        [
          "Commercial"
        ]
      ],
      [
        1489,
        [
          "Installations"
        ]
      ]
    ]

    data.each do |item|
      pr = Project.find_by_old_id item[0]
      item[1].each do |t|
        pt = ProjectType.find_by_title t
        pr.project_types << pt
      end


    end
  end

  task generate_search_results: :environment do
    SearchResult.destroy_all

    [Award, NewsItem, Person, Project].each do |model|
      model.all.each do |instance|
        instance.autocreate_searchable
        instance.update_search_content
      end
    end
  end

  task remove_duplicate_of_primary_image: :environment do
    [Award, BibliographyItem, NewsItem, Person, Project].each do |model|
      model.all.each do |item|

        if item.primary_image && item.primary_image.name_url
          dup = item.uploads.select{|u| File.basename(u.name_url) == File.basename(item.primary_image.name_url)}
          if dup.count > 0
            puts [dup.first.id, dup.first.name_url, item.primary_image.id, item.primary_image.name_url]
          end
        end

      end
    end
  end

  task add_ranks_to_roles: :environment do
    DB = Sequel.connect('postgres://cooper:home3232@localhost:5432/test')
    roles = DB['select d.rank as rank, a.id as project_id, a.title as project_title, e.id as position_id, e.title as position_title, c.id as person_id, c.title as person_title
      from article as a
      join articles_related as b
      on a.id = b.article_id
      join article as c
      on b.article_related_id = c.id
      join articles_people_positions as d
      on b.id = d.related_id
      join people_positions as e
      on d.position_id = e.id']
    roles.each do |role|
      found =  Role.all.select{|r| r.project.old_id == role[:project_id] &&  r.person.old_id == role[:person_id] && r.position.old_id == role[:position_id] }.first

      if found  
        found.rank = role[:rank]
        puts found.save
      end
    end
  end

end
