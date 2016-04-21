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
  	ranks = [{:id=>2, :rank=>99999999}, {:id=>3, :rank=>99999999}, {:id=>5, :rank=>99999999}, {:id=>6, :rank=>99999999}, {:id=>7, :rank=>99999999}, {:id=>8, :rank=>99999999}, {:id=>9, :rank=>99999999}, {:id=>10, :rank=>99999999}, {:id=>11, :rank=>99999999}, {:id=>12, :rank=>99999999}, {:id=>13, :rank=>99999999}, {:id=>14, :rank=>99999999}, {:id=>15, :rank=>99999999}, {:id=>16, :rank=>99999999}, {:id=>17, :rank=>99999999}, {:id=>18, :rank=>99999999}, {:id=>19, :rank=>99999999}, {:id=>20, :rank=>99999999}, {:id=>22, :rank=>99999999}, {:id=>23, :rank=>99999999}, {:id=>24, :rank=>99999999}, {:id=>25, :rank=>99999999}, {:id=>26, :rank=>99999999}, {:id=>27, :rank=>99999999}, {:id=>28, :rank=>99999999}, {:id=>29, :rank=>99999999}, {:id=>30, :rank=>99999999}, {:id=>31, :rank=>99999999}, {:id=>32, :rank=>99999999}, {:id=>33, :rank=>99999999}, {:id=>34, :rank=>99999999}, {:id=>35, :rank=>99999999}, {:id=>36, :rank=>99999999}, {:id=>37, :rank=>99999999}, {:id=>39, :rank=>99999999}, {:id=>40, :rank=>99999999}, {:id=>41, :rank=>99999999}, {:id=>42, :rank=>99999999}, {:id=>43, :rank=>99999999}, {:id=>44, :rank=>99999999}, {:id=>45, :rank=>99999999}, {:id=>46, :rank=>99999999}, {:id=>47, :rank=>99999999}, {:id=>48, :rank=>99999999}, {:id=>49, :rank=>99999999}, {:id=>50, :rank=>99999999}, {:id=>51, :rank=>99999999}, {:id=>52, :rank=>99999999}, {:id=>53, :rank=>99999999}, {:id=>54, :rank=>99999999}, {:id=>56, :rank=>99999999}, {:id=>57, :rank=>99999999}, {:id=>58, :rank=>99999999}, {:id=>59, :rank=>99999999}, {:id=>60, :rank=>99999999}, {:id=>61, :rank=>99999999}, {:id=>62, :rank=>99999999}, {:id=>63, :rank=>99999999}, {:id=>64, :rank=>99999999}, {:id=>65, :rank=>99999999}, {:id=>66, :rank=>99999999}, {:id=>67, :rank=>99999999}, {:id=>68, :rank=>99999999}, {:id=>69, :rank=>99999999}, {:id=>70, :rank=>99999999}, {:id=>71, :rank=>99999999}, {:id=>73, :rank=>99999999}, {:id=>74, :rank=>99999999}, {:id=>75, :rank=>99999999}, {:id=>76, :rank=>99999999}, {:id=>77, :rank=>99999999}, {:id=>78, :rank=>99999999}, {:id=>79, :rank=>99999999}, {:id=>80, :rank=>99999999}, {:id=>81, :rank=>99999999}, {:id=>82, :rank=>99999999}, {:id=>83, :rank=>99999999}, {:id=>84, :rank=>99999999}, {:id=>85, :rank=>99999999}, {:id=>86, :rank=>99999999}, {:id=>87, :rank=>99999999}, {:id=>88, :rank=>99999999}, {:id=>90, :rank=>99999999}, {:id=>91, :rank=>99999999}, {:id=>92, :rank=>99999999}, {:id=>93, :rank=>99999999}, {:id=>94, :rank=>99999999}, {:id=>95, :rank=>99999999}, {:id=>96, :rank=>99999999}, {:id=>97, :rank=>99999999}, {:id=>98, :rank=>99999999}, {:id=>99, :rank=>99999999}, {:id=>100, :rank=>99999999}, {:id=>101, :rank=>99999999}, {:id=>102, :rank=>99999999}, {:id=>103, :rank=>99999999}, {:id=>104, :rank=>99999999}, {:id=>105, :rank=>99999999}, {:id=>107, :rank=>99999999}, {:id=>108, :rank=>99999999}, {:id=>109, :rank=>99999999}, {:id=>110, :rank=>99999999}, {:id=>111, :rank=>99999999}, {:id=>112, :rank=>99999999}, {:id=>113, :rank=>99999999}, {:id=>114, :rank=>99999999}, {:id=>115, :rank=>99999999}, {:id=>116, :rank=>99999999}, {:id=>117, :rank=>99999999}, {:id=>118, :rank=>99999999}, {:id=>119, :rank=>99999999}, {:id=>120, :rank=>99999999}, {:id=>122, :rank=>99999999}, {:id=>123, :rank=>99999999}, {:id=>125, :rank=>99999999}, {:id=>126, :rank=>99999999}, {:id=>127, :rank=>99999999}, {:id=>128, :rank=>99999999}, {:id=>129, :rank=>99999999}, {:id=>130, :rank=>99999999}, {:id=>131, :rank=>99999999}, {:id=>132, :rank=>99999999}, {:id=>133, :rank=>99999999}, {:id=>134, :rank=>99999999}, {:id=>135, :rank=>99999999}, {:id=>136, :rank=>99999999}, {:id=>137, :rank=>99999999}, {:id=>138, :rank=>99999999}, {:id=>139, :rank=>99999999}, {:id=>140, :rank=>99999999}, {:id=>142, :rank=>99999999}, {:id=>143, :rank=>99999999}, {:id=>144, :rank=>99999999}, {:id=>145, :rank=>99999999}, {:id=>146, :rank=>99999999}, {:id=>147, :rank=>99999999}, {:id=>148, :rank=>99999999}, {:id=>149, :rank=>99999999}, {:id=>150, :rank=>99999999}, {:id=>151, :rank=>99999999}, {:id=>152, :rank=>99999999}, {:id=>153, :rank=>99999999}, {:id=>154, :rank=>99999999}, {:id=>155, :rank=>99999999}, {:id=>156, :rank=>99999999}, {:id=>157, :rank=>99999999}, {:id=>159, :rank=>99999999}, {:id=>160, :rank=>99999999}, {:id=>161, :rank=>99999999}, {:id=>162, :rank=>99999999}, {:id=>163, :rank=>99999999}, {:id=>164, :rank=>99999999}, {:id=>165, :rank=>99999999}, {:id=>166, :rank=>99999999}, {:id=>167, :rank=>99999999}, {:id=>168, :rank=>99999999}, {:id=>169, :rank=>99999999}, {:id=>170, :rank=>99999999}, {:id=>171, :rank=>99999999}, {:id=>172, :rank=>99999999}, {:id=>173, :rank=>99999999}, {:id=>174, :rank=>99999999}, {:id=>176, :rank=>99999999}, {:id=>177, :rank=>99999999}, {:id=>178, :rank=>99999999}, {:id=>179, :rank=>99999999}, {:id=>180, :rank=>99999999}, {:id=>181, :rank=>99999999}, {:id=>182, :rank=>99999999}, {:id=>183, :rank=>99999999}, {:id=>184, :rank=>99999999}, {:id=>185, :rank=>99999999}, {:id=>186, :rank=>99999999}, {:id=>187, :rank=>99999999}, {:id=>188, :rank=>99999999}, {:id=>189, :rank=>99999999}, {:id=>190, :rank=>99999999}, {:id=>191, :rank=>99999999}, {:id=>193, :rank=>99999999}, {:id=>194, :rank=>99999999}, {:id=>195, :rank=>99999999}, {:id=>196, :rank=>99999999}, {:id=>197, :rank=>99999999}, {:id=>198, :rank=>99999999}, {:id=>199, :rank=>99999999}, {:id=>200, :rank=>99999999}, {:id=>201, :rank=>99999999}, {:id=>202, :rank=>99999999}, {:id=>203, :rank=>99999999}, {:id=>204, :rank=>99999999}, {:id=>205, :rank=>99999999}, {:id=>206, :rank=>99999999}, {:id=>207, :rank=>99999999}, {:id=>208, :rank=>99999999}, {:id=>210, :rank=>99999999}, {:id=>211, :rank=>99999999}, {:id=>212, :rank=>99999999}, {:id=>213, :rank=>99999999}, {:id=>214, :rank=>99999999}, {:id=>215, :rank=>99999999}, {:id=>216, :rank=>99999999}, {:id=>217, :rank=>99999999}, {:id=>218, :rank=>99999999}, {:id=>219, :rank=>99999999}, {:id=>220, :rank=>99999999}, {:id=>221, :rank=>99999999}, {:id=>222, :rank=>99999999}, {:id=>223, :rank=>99999999}, {:id=>224, :rank=>99999999}, {:id=>225, :rank=>99999999}, {:id=>227, :rank=>99999999}, {:id=>228, :rank=>99999999}, {:id=>229, :rank=>99999999}, {:id=>230, :rank=>99999999}, {:id=>231, :rank=>99999999}, {:id=>232, :rank=>99999999}, {:id=>233, :rank=>99999999}, {:id=>234, :rank=>99999999}, {:id=>235, :rank=>99999999}, {:id=>236, :rank=>2}, {:id=>237, :rank=>1}, {:id=>238, :rank=>2}, {:id=>239, :rank=>1}, {:id=>240, :rank=>3}, {:id=>242, :rank=>99999999}, {:id=>243, :rank=>99999999}, {:id=>245, :rank=>99999999}, {:id=>246, :rank=>99999999}, {:id=>247, :rank=>99999999}, {:id=>248, :rank=>99999999}, {:id=>249, :rank=>99999999}, {:id=>250, :rank=>99999999}, {:id=>251, :rank=>99999999}, {:id=>252, :rank=>99999999}, {:id=>253, :rank=>99999999}, {:id=>254, :rank=>99999999}, {:id=>255, :rank=>99999999}, {:id=>256, :rank=>99999999}, {:id=>257, :rank=>99999999}, {:id=>258, :rank=>99999999}, {:id=>259, :rank=>99999999}, {:id=>260, :rank=>99999999}, {:id=>262, :rank=>99999999}, {:id=>263, :rank=>99999999}, {:id=>264, :rank=>99999999}, {:id=>265, :rank=>99999999}, {:id=>266, :rank=>99999999}, {:id=>267, :rank=>99999999}, {:id=>268, :rank=>99999999}, {:id=>269, :rank=>99999999}, {:id=>270, :rank=>99999999}, {:id=>271, :rank=>99999999}, {:id=>272, :rank=>99999999}, {:id=>273, :rank=>99999999}, {:id=>274, :rank=>99999999}, {:id=>275, :rank=>99999999}, {:id=>276, :rank=>99999999}, {:id=>277, :rank=>99999999}, {:id=>279, :rank=>99999999}, {:id=>280, :rank=>99999999}, {:id=>281, :rank=>99999999}, {:id=>282, :rank=>99999999}, {:id=>283, :rank=>99999999}, {:id=>284, :rank=>99999999}, {:id=>285, :rank=>99999999}, {:id=>286, :rank=>99999999}, {:id=>287, :rank=>99999999}, {:id=>288, :rank=>99999999}, {:id=>289, :rank=>99999999}, {:id=>290, :rank=>99999999}, {:id=>291, :rank=>99999999}, {:id=>292, :rank=>99999999}, {:id=>293, :rank=>99999999}, {:id=>294, :rank=>99999999}, {:id=>296, :rank=>99999999}, {:id=>297, :rank=>99999999}, {:id=>298, :rank=>99999999}, {:id=>299, :rank=>99999999}, {:id=>300, :rank=>99999999}, {:id=>301, :rank=>99999999}, {:id=>302, :rank=>99999999}, {:id=>303, :rank=>99999999}, {:id=>304, :rank=>99999999}, {:id=>305, :rank=>99999999}, {:id=>306, :rank=>99999999}, {:id=>307, :rank=>99999999}, {:id=>308, :rank=>99999999}, {:id=>309, :rank=>99999999}, {:id=>310, :rank=>99999999}, {:id=>311, :rank=>99999999}, {:id=>313, :rank=>99999999}, {:id=>314, :rank=>99999999}, {:id=>315, :rank=>99999999}, {:id=>316, :rank=>99999999}, {:id=>317, :rank=>99999999}, {:id=>318, :rank=>99999999}, {:id=>319, :rank=>99999999}, {:id=>320, :rank=>99999999}, {:id=>321, :rank=>99999999}, {:id=>322, :rank=>99999999}, {:id=>323, :rank=>99999999}, {:id=>324, :rank=>99999999}, {:id=>325, :rank=>99999999}, {:id=>326, :rank=>99999999}, {:id=>327, :rank=>99999999}, {:id=>328, :rank=>99999999}, {:id=>330, :rank=>99999999}, {:id=>331, :rank=>99999999}, {:id=>332, :rank=>99999999}, {:id=>333, :rank=>99999999}, {:id=>334, :rank=>99999999}, {:id=>335, :rank=>99999999}, {:id=>336, :rank=>99999999}, {:id=>337, :rank=>99999999}, {:id=>338, :rank=>99999999}, {:id=>339, :rank=>99999999}, {:id=>340, :rank=>99999999}, {:id=>341, :rank=>99999999}, {:id=>342, :rank=>99999999}, {:id=>343, :rank=>99999999}, {:id=>344, :rank=>99999999}, {:id=>345, :rank=>99999999}, {:id=>347, :rank=>99999999}, {:id=>348, :rank=>99999999}, {:id=>349, :rank=>99999999}, {:id=>350, :rank=>99999999}, {:id=>351, :rank=>99999999}, {:id=>352, :rank=>99999999}, {:id=>353, :rank=>99999999}, {:id=>354, :rank=>99999999}, {:id=>355, :rank=>99999999}, {:id=>356, :rank=>99999999}, {:id=>357, :rank=>99999999}, {:id=>358, :rank=>99999999}, {:id=>359, :rank=>99999999}, {:id=>360, :rank=>99999999}, {:id=>362, :rank=>99999999}, {:id=>363, :rank=>99999999}, {:id=>365, :rank=>99999999}, {:id=>366, :rank=>99999999}, {:id=>367, :rank=>99999999}, {:id=>368, :rank=>99999999}, {:id=>369, :rank=>99999999}, {:id=>370, :rank=>99999999}, {:id=>371, :rank=>99999999}, {:id=>372, :rank=>99999999}, {:id=>373, :rank=>99999999}, {:id=>374, :rank=>99999999}, {:id=>375, :rank=>99999999}, {:id=>376, :rank=>99999999}, {:id=>377, :rank=>99999999}, {:id=>378, :rank=>99999999}, {:id=>379, :rank=>99999999}, {:id=>380, :rank=>99999999}, {:id=>382, :rank=>99999999}, {:id=>383, :rank=>99999999}, {:id=>384, :rank=>99999999}, {:id=>385, :rank=>99999999}, {:id=>386, :rank=>99999999}, {:id=>387, :rank=>99999999}, {:id=>388, :rank=>99999999}, {:id=>389, :rank=>99999999}, {:id=>390, :rank=>99999999}, {:id=>391, :rank=>99999999}, {:id=>392, :rank=>99999999}, {:id=>393, :rank=>99999999}, {:id=>394, :rank=>99999999}, {:id=>395, :rank=>99999999}, {:id=>396, :rank=>99999999}, {:id=>397, :rank=>99999999}, {:id=>399, :rank=>99999999}, {:id=>400, :rank=>99999999}, {:id=>401, :rank=>99999999}, {:id=>402, :rank=>99999999}, {:id=>403, :rank=>99999999}, {:id=>404, :rank=>99999999}, {:id=>405, :rank=>99999999}, {:id=>406, :rank=>99999999}, {:id=>407, :rank=>99999999}, {:id=>408, :rank=>99999999}, {:id=>409, :rank=>99999999}, {:id=>410, :rank=>99999999}, {:id=>411, :rank=>99999999}, {:id=>412, :rank=>99999999}, {:id=>413, :rank=>99999999}, {:id=>414, :rank=>99999999}, {:id=>416, :rank=>99999999}, {:id=>417, :rank=>99999999}, {:id=>418, :rank=>99999999}, {:id=>419, :rank=>99999999}, {:id=>420, :rank=>99999999}, {:id=>421, :rank=>99999999}, {:id=>422, :rank=>99999999}, {:id=>423, :rank=>99999999}, {:id=>424, :rank=>99999999}, {:id=>425, :rank=>99999999}, {:id=>426, :rank=>99999999}, {:id=>427, :rank=>99999999}, {:id=>428, :rank=>99999999}, {:id=>429, :rank=>99999999}, {:id=>430, :rank=>99999999}, {:id=>431, :rank=>99999999}, {:id=>433, :rank=>99999999}, {:id=>434, :rank=>99999999}, {:id=>435, :rank=>99999999}, {:id=>436, :rank=>99999999}, {:id=>437, :rank=>99999999}, {:id=>438, :rank=>99999999}, {:id=>439, :rank=>99999999}, {:id=>440, :rank=>99999999}, {:id=>441, :rank=>99999999}, {:id=>442, :rank=>99999999}, {:id=>443, :rank=>99999999}, {:id=>444, :rank=>99999999}, {:id=>445, :rank=>99999999}, {:id=>446, :rank=>99999999}, {:id=>447, :rank=>99999999}, {:id=>448, :rank=>99999999}, {:id=>450, :rank=>99999999}, {:id=>451, :rank=>99999999}, {:id=>452, :rank=>99999999}, {:id=>453, :rank=>99999999}, {:id=>454, :rank=>99999999}, {:id=>455, :rank=>99999999}, {:id=>456, :rank=>99999999}, {:id=>457, :rank=>99999999}, {:id=>458, :rank=>99999999}, {:id=>459, :rank=>99999999}, {:id=>460, :rank=>99999999}, {:id=>461, :rank=>99999999}, {:id=>462, :rank=>99999999}, {:id=>463, :rank=>99999999}, {:id=>464, :rank=>99999999}, {:id=>465, :rank=>99999999}, {:id=>467, :rank=>99999999}, {:id=>468, :rank=>99999999}, {:id=>469, :rank=>99999999}, {:id=>470, :rank=>99999999}, {:id=>471, :rank=>99999999}, {:id=>472, :rank=>99999999}, {:id=>473, :rank=>99999999}, {:id=>474, :rank=>99999999}, {:id=>475, :rank=>99999999}, {:id=>476, :rank=>99999999}, {:id=>477, :rank=>99999999}, {:id=>478, :rank=>99999999}, {:id=>479, :rank=>99999999}, {:id=>480, :rank=>99999999}, {:id=>482, :rank=>99999999}, {:id=>483, :rank=>99999999}, {:id=>485, :rank=>99999999}, {:id=>486, :rank=>99999999}, {:id=>487, :rank=>99999999}, {:id=>488, :rank=>99999999}, {:id=>489, :rank=>99999999}, {:id=>490, :rank=>99999999}, {:id=>491, :rank=>99999999}, {:id=>492, :rank=>99999999}, {:id=>493, :rank=>99999999}, {:id=>494, :rank=>99999999}, {:id=>495, :rank=>99999999}, {:id=>496, :rank=>99999999}, {:id=>497, :rank=>99999999}, {:id=>498, :rank=>99999999}, {:id=>499, :rank=>99999999}, {:id=>500, :rank=>99999999}, {:id=>502, :rank=>99999999}, {:id=>503, :rank=>99999999}, {:id=>504, :rank=>99999999}, {:id=>505, :rank=>99999999}, {:id=>506, :rank=>99999999}, {:id=>507, :rank=>99999999}, {:id=>508, :rank=>99999999}, {:id=>509, :rank=>99999999}, {:id=>510, :rank=>99999999}, {:id=>511, :rank=>99999999}, {:id=>512, :rank=>99999999}, {:id=>513, :rank=>99999999}, {:id=>514, :rank=>99999999}, {:id=>515, :rank=>99999999}, {:id=>516, :rank=>99999999}, {:id=>517, :rank=>99999999}, {:id=>519, :rank=>99999999}, {:id=>520, :rank=>99999999}, {:id=>521, :rank=>99999999}, {:id=>522, :rank=>99999999}, {:id=>523, :rank=>99999999}, {:id=>524, :rank=>99999999}, {:id=>525, :rank=>99999999}, {:id=>526, :rank=>99999999}, {:id=>527, :rank=>99999999}, {:id=>528, :rank=>99999999}, {:id=>529, :rank=>99999999}, {:id=>530, :rank=>99999999}, {:id=>531, :rank=>99999999}, {:id=>532, :rank=>99999999}, {:id=>533, :rank=>99999999}, {:id=>534, :rank=>99999999}, {:id=>536, :rank=>99999999}, {:id=>537, :rank=>99999999}, {:id=>538, :rank=>99999999}, {:id=>539, :rank=>99999999}, {:id=>540, :rank=>99999999}, {:id=>541, :rank=>99999999}, {:id=>542, :rank=>99999999}, {:id=>543, :rank=>99999999}, {:id=>544, :rank=>99999999}, {:id=>545, :rank=>99999999}, {:id=>546, :rank=>99999999}, {:id=>547, :rank=>99999999}, {:id=>548, :rank=>99999999}, {:id=>549, :rank=>99999999}, {:id=>550, :rank=>99999999}, {:id=>551, :rank=>99999999}, {:id=>553, :rank=>99999999}, {:id=>554, :rank=>99999999}, {:id=>555, :rank=>99999999}, {:id=>556, :rank=>99999999}, {:id=>557, :rank=>99999999}, {:id=>558, :rank=>99999999}, {:id=>559, :rank=>99999999}, {:id=>560, :rank=>99999999}, {:id=>561, :rank=>99999999}, {:id=>562, :rank=>99999999}, {:id=>563, :rank=>99999999}, {:id=>564, :rank=>99999999}, {:id=>565, :rank=>99999999}, {:id=>566, :rank=>99999999}, {:id=>567, :rank=>99999999}, {:id=>568, :rank=>99999999}, {:id=>570, :rank=>99999999}, {:id=>571, :rank=>99999999}, {:id=>572, :rank=>99999999}, {:id=>573, :rank=>99999999}, {:id=>574, :rank=>99999999}, {:id=>575, :rank=>99999999}, {:id=>576, :rank=>99999999}, {:id=>577, :rank=>99999999}, {:id=>578, :rank=>99999999}, {:id=>579, :rank=>99999999}, {:id=>580, :rank=>99999999}, {:id=>581, :rank=>99999999}, {:id=>582, :rank=>99999999}, {:id=>583, :rank=>99999999}, {:id=>584, :rank=>99999999}, {:id=>585, :rank=>99999999}, {:id=>587, :rank=>99999999}, {:id=>588, :rank=>99999999}, {:id=>589, :rank=>99999999}, {:id=>590, :rank=>99999999}, {:id=>591, :rank=>99999999}, {:id=>592, :rank=>99999999}, {:id=>593, :rank=>99999999}, {:id=>594, :rank=>99999999}, {:id=>595, :rank=>99999999}, {:id=>596, :rank=>99999999}, {:id=>597, :rank=>99999999}, {:id=>598, :rank=>99999999}, {:id=>599, :rank=>99999999}, {:id=>600, :rank=>99999999}, {:id=>602, :rank=>99999999}, {:id=>603, :rank=>99999999}, {:id=>605, :rank=>99999999}, {:id=>606, :rank=>99999999}, {:id=>607, :rank=>99999999}, {:id=>608, :rank=>99999999}, {:id=>609, :rank=>99999999}, {:id=>610, :rank=>99999999}, {:id=>611, :rank=>99999999}, {:id=>612, :rank=>99999999}, {:id=>613, :rank=>99999999}, {:id=>614, :rank=>99999999}, {:id=>615, :rank=>99999999}, {:id=>616, :rank=>99999999}, {:id=>617, :rank=>99999999}, {:id=>618, :rank=>99999999}, {:id=>619, :rank=>99999999}, {:id=>620, :rank=>99999999}, {:id=>622, :rank=>99999999}, {:id=>623, :rank=>99999999}, {:id=>624, :rank=>99999999}, {:id=>625, :rank=>99999999}, {:id=>626, :rank=>99999999}, {:id=>627, :rank=>99999999}, {:id=>628, :rank=>99999999}, {:id=>629, :rank=>99999999}, {:id=>630, :rank=>99999999}, {:id=>631, :rank=>99999999}, {:id=>632, :rank=>99999999}, {:id=>633, :rank=>99999999}, {:id=>634, :rank=>99999999}, {:id=>635, :rank=>99999999}, {:id=>636, :rank=>99999999}, {:id=>637, :rank=>99999999}, {:id=>639, :rank=>99999999}, {:id=>640, :rank=>99999999}, {:id=>641, :rank=>99999999}, {:id=>642, :rank=>99999999}, {:id=>643, :rank=>99999999}, {:id=>644, :rank=>99999999}, {:id=>645, :rank=>99999999}, {:id=>646, :rank=>99999999}, {:id=>647, :rank=>99999999}, {:id=>648, :rank=>99999999}, {:id=>649, :rank=>99999999}, {:id=>650, :rank=>99999999}, {:id=>651, :rank=>99999999}, {:id=>652, :rank=>99999999}, {:id=>653, :rank=>99999999}, {:id=>654, :rank=>99999999}, {:id=>656, :rank=>99999999}, {:id=>657, :rank=>99999999}, {:id=>658, :rank=>99999999}, {:id=>659, :rank=>99999999}, {:id=>660, :rank=>99999999}, {:id=>661, :rank=>99999999}, {:id=>662, :rank=>99999999}, {:id=>663, :rank=>99999999}, {:id=>664, :rank=>99999999}, {:id=>665, :rank=>99999999}, {:id=>666, :rank=>99999999}, {:id=>667, :rank=>99999999}, {:id=>668, :rank=>99999999}, {:id=>669, :rank=>99999999}, {:id=>670, :rank=>99999999}, {:id=>671, :rank=>99999999}, {:id=>673, :rank=>99999999}, {:id=>674, :rank=>99999999}, {:id=>675, :rank=>99999999}, {:id=>676, :rank=>99999999}, {:id=>677, :rank=>99999999}, {:id=>678, :rank=>99999999}, {:id=>679, :rank=>99999999}, {:id=>680, :rank=>99999999}, {:id=>681, :rank=>99999999}, {:id=>682, :rank=>99999999}, {:id=>683, :rank=>99999999}, {:id=>684, :rank=>99999999}, {:id=>685, :rank=>99999999}, {:id=>686, :rank=>99999999}, {:id=>687, :rank=>99999999}, {:id=>688, :rank=>99999999}, {:id=>690, :rank=>99999999}, {:id=>691, :rank=>99999999}, {:id=>692, :rank=>99999999}, {:id=>693, :rank=>99999999}, {:id=>694, :rank=>99999999}, {:id=>695, :rank=>99999999}, {:id=>696, :rank=>99999999}, {:id=>697, :rank=>99999999}, {:id=>698, :rank=>99999999}, {:id=>699, :rank=>99999999}, {:id=>700, :rank=>99999999}, {:id=>701, :rank=>99999999}, {:id=>702, :rank=>99999999}, {:id=>703, :rank=>99999999}, {:id=>704, :rank=>99999999}, {:id=>705, :rank=>99999999}, {:id=>707, :rank=>99999999}, {:id=>708, :rank=>99999999}, {:id=>709, :rank=>99999999}, {:id=>710, :rank=>99999999}, {:id=>711, :rank=>99999999}, {:id=>712, :rank=>99999999}, {:id=>713, :rank=>99999999}, {:id=>714, :rank=>99999999}, {:id=>715, :rank=>99999999}, {:id=>716, :rank=>99999999}, {:id=>717, :rank=>99999999}, {:id=>718, :rank=>99999999}, {:id=>719, :rank=>99999999}, {:id=>720, :rank=>99999999}, {:id=>722, :rank=>99999999}, {:id=>723, :rank=>99999999}, {:id=>725, :rank=>99999999}, {:id=>726, :rank=>99999999}, {:id=>727, :rank=>99999999}, {:id=>728, :rank=>99999999}, {:id=>729, :rank=>99999999}, {:id=>730, :rank=>99999999}, {:id=>731, :rank=>99999999}, {:id=>732, :rank=>99999999}, {:id=>733, :rank=>2}, {:id=>734, :rank=>1}, {:id=>735, :rank=>4}, {:id=>736, :rank=>3}, {:id=>737, :rank=>5}, {:id=>738, :rank=>6}, {:id=>739, :rank=>7}, {:id=>740, :rank=>8}, {:id=>742, :rank=>11}, {:id=>743, :rank=>9}, {:id=>744, :rank=>12}, {:id=>745, :rank=>13}, {:id=>746, :rank=>4}, {:id=>747, :rank=>1}, {:id=>748, :rank=>99999999}, {:id=>749, :rank=>99999999}, {:id=>750, :rank=>99999999}, {:id=>751, :rank=>99999999}, {:id=>752, :rank=>99999999}, {:id=>753, :rank=>99999999}, {:id=>754, :rank=>99999999}, {:id=>755, :rank=>99999999}, {:id=>756, :rank=>99999999}, {:id=>757, :rank=>99999999}, {:id=>759, :rank=>99999999}, {:id=>760, :rank=>99999999}, {:id=>761, :rank=>99999999}, {:id=>762, :rank=>99999999}, {:id=>763, :rank=>99999999}, {:id=>764, :rank=>99999999}, {:id=>765, :rank=>99999999}, {:id=>766, :rank=>99999999}, {:id=>767, :rank=>99999999}, {:id=>768, :rank=>99999999}, {:id=>769, :rank=>99999999}, {:id=>770, :rank=>99999999}, {:id=>771, :rank=>99999999}, {:id=>772, :rank=>99999999}, {:id=>773, :rank=>99999999}, {:id=>774, :rank=>99999999}, {:id=>776, :rank=>99999999}, {:id=>777, :rank=>99999999}, {:id=>778, :rank=>99999999}, {:id=>779, :rank=>99999999}, {:id=>780, :rank=>99999999}, {:id=>781, :rank=>99999999}, {:id=>782, :rank=>99999999}, {:id=>783, :rank=>99999999}, {:id=>784, :rank=>99999999}, {:id=>785, :rank=>99999999}, {:id=>786, :rank=>99999999}, {:id=>787, :rank=>99999999}, {:id=>788, :rank=>99999999}, {:id=>789, :rank=>99999999}, {:id=>790, :rank=>99999999}, {:id=>791, :rank=>99999999}, {:id=>793, :rank=>99999999}, {:id=>794, :rank=>99999999}, {:id=>795, :rank=>99999999}, {:id=>796, :rank=>99999999}, {:id=>797, :rank=>99999999}, {:id=>798, :rank=>99999999}, {:id=>799, :rank=>99999999}, {:id=>800, :rank=>99999999}, {:id=>801, :rank=>99999999}, {:id=>802, :rank=>99999999}, {:id=>803, :rank=>99999999}, {:id=>804, :rank=>99999999}, {:id=>805, :rank=>99999999}, {:id=>806, :rank=>99999999}, {:id=>807, :rank=>99999999}, {:id=>808, :rank=>99999999}, {:id=>810, :rank=>99999999}, {:id=>811, :rank=>99999999}, {:id=>812, :rank=>99999999}, {:id=>813, :rank=>99999999}, {:id=>814, :rank=>99999999}, {:id=>815, :rank=>99999999}, {:id=>816, :rank=>99999999}, {:id=>817, :rank=>99999999}, {:id=>818, :rank=>99999999}, {:id=>819, :rank=>99999999}, {:id=>820, :rank=>99999999}, {:id=>821, :rank=>99999999}, {:id=>822, :rank=>99999999}, {:id=>823, :rank=>99999999}, {:id=>824, :rank=>99999999}, {:id=>825, :rank=>99999999}, {:id=>827, :rank=>99999999}, {:id=>828, :rank=>99999999}, {:id=>829, :rank=>99999999}, {:id=>830, :rank=>99999999}, {:id=>831, :rank=>99999999}, {:id=>832, :rank=>99999999}, {:id=>833, :rank=>99999999}, {:id=>834, :rank=>99999999}, {:id=>835, :rank=>99999999}, {:id=>836, :rank=>2}, {:id=>837, :rank=>1}, {:id=>838, :rank=>3}, {:id=>839, :rank=>4}, {:id=>840, :rank=>5}, {:id=>842, :rank=>99999999}, {:id=>843, :rank=>99999999}, {:id=>845, :rank=>99999999}, {:id=>846, :rank=>99999999}, {:id=>847, :rank=>99999999}, {:id=>848, :rank=>99999999}, {:id=>849, :rank=>99999999}, {:id=>850, :rank=>99999999}, {:id=>851, :rank=>99999999}, {:id=>852, :rank=>99999999}, {:id=>853, :rank=>99999999}, {:id=>854, :rank=>99999999}, {:id=>855, :rank=>99999999}, {:id=>856, :rank=>99999999}, {:id=>857, :rank=>99999999}, {:id=>858, :rank=>99999999}, {:id=>859, :rank=>99999999}, {:id=>860, :rank=>99999999}, {:id=>862, :rank=>99999999}, {:id=>863, :rank=>99999999}, {:id=>864, :rank=>99999999}, {:id=>865, :rank=>99999999}, {:id=>866, :rank=>99999999}, {:id=>867, :rank=>99999999}, {:id=>868, :rank=>99999999}, {:id=>869, :rank=>99999999}, {:id=>870, :rank=>99999999}, {:id=>871, :rank=>99999999}, {:id=>872, :rank=>2}, {:id=>873, :rank=>1}, {:id=>874, :rank=>99999999}, {:id=>875, :rank=>99999999}, {:id=>876, :rank=>99999999}, {:id=>877, :rank=>99999999}, {:id=>879, :rank=>99999999}, {:id=>880, :rank=>99999999}, {:id=>881, :rank=>99999999}, {:id=>882, :rank=>99999999}, {:id=>883, :rank=>99999999}, {:id=>884, :rank=>99999999}, {:id=>885, :rank=>99999999}, {:id=>886, :rank=>99999999}, {:id=>887, :rank=>99999999}, {:id=>888, :rank=>99999999}, {:id=>889, :rank=>99999999}, {:id=>890, :rank=>99999999}, {:id=>891, :rank=>99999999}, {:id=>892, :rank=>99999999}, {:id=>893, :rank=>99999999}, {:id=>894, :rank=>99999999}, {:id=>896, :rank=>99999999}, {:id=>897, :rank=>99999999}, {:id=>898, :rank=>99999999}, {:id=>899, :rank=>99999999}, {:id=>900, :rank=>99999999}, {:id=>901, :rank=>99999999}, {:id=>902, :rank=>99999999}, {:id=>903, :rank=>99999999}, {:id=>904, :rank=>99999999}, {:id=>905, :rank=>99999999}, {:id=>906, :rank=>99999999}, {:id=>907, :rank=>99999999}, {:id=>908, :rank=>1}, {:id=>909, :rank=>3}, {:id=>910, :rank=>4}, {:id=>911, :rank=>1}, {:id=>913, :rank=>28}, {:id=>914, :rank=>19}, {:id=>915, :rank=>17}, {:id=>916, :rank=>3}, {:id=>917, :rank=>5}, {:id=>918, :rank=>18}, {:id=>919, :rank=>11}, {:id=>920, :rank=>27}, {:id=>921, :rank=>13}, {:id=>922, :rank=>15}, {:id=>923, :rank=>14}, {:id=>924, :rank=>11}, {:id=>925, :rank=>8}, {:id=>926, :rank=>20}, {:id=>927, :rank=>22}, {:id=>928, :rank=>16}, {:id=>930, :rank=>23}, {:id=>931, :rank=>24}, {:id=>932, :rank=>7}, {:id=>933, :rank=>25}, {:id=>934, :rank=>26}, {:id=>935, :rank=>21}, {:id=>936, :rank=>6}, {:id=>937, :rank=>2}, {:id=>938, :rank=>99999999}, {:id=>939, :rank=>99999999}, {:id=>940, :rank=>99999999}, {:id=>941, :rank=>99999999}, {:id=>942, :rank=>99999999}, {:id=>943, :rank=>99999999}, {:id=>944, :rank=>99999999}, {:id=>945, :rank=>99999999}, {:id=>947, :rank=>99999999}, {:id=>948, :rank=>99999999}, {:id=>949, :rank=>99999999}, {:id=>950, :rank=>99999999}, {:id=>951, :rank=>99999999}, {:id=>952, :rank=>99999999}, {:id=>953, :rank=>99999999}, {:id=>954, :rank=>99999999}, {:id=>955, :rank=>99999999}, {:id=>956, :rank=>99999999}, {:id=>957, :rank=>99999999}, {:id=>958, :rank=>99999999}, {:id=>959, :rank=>99999999}, {:id=>960, :rank=>99999999}, {:id=>962, :rank=>3}, {:id=>963, :rank=>5}, {:id=>965, :rank=>1}, {:id=>966, :rank=>18}, {:id=>967, :rank=>6}, {:id=>968, :rank=>2}, {:id=>969, :rank=>2}, {:id=>970, :rank=>17}, {:id=>971, :rank=>11}, {:id=>972, :rank=>14}, {:id=>973, :rank=>12}, {:id=>974, :rank=>15}, {:id=>975, :rank=>16}, {:id=>976, :rank=>8}, {:id=>977, :rank=>10}, {:id=>978, :rank=>9}, {:id=>979, :rank=>13}, {:id=>980, :rank=>7}, {:id=>982, :rank=>20}, {:id=>983, :rank=>21}, {:id=>984, :rank=>99999999}, {:id=>985, :rank=>99999999}, {:id=>986, :rank=>99999999}, {:id=>987, :rank=>99999999}, {:id=>988, :rank=>99999999}, {:id=>989, :rank=>99999999}, {:id=>990, :rank=>99999999}, {:id=>991, :rank=>99999999}, {:id=>992, :rank=>99999999}, {:id=>993, :rank=>99999999}, {:id=>994, :rank=>99999999}, {:id=>995, :rank=>99999999}, {:id=>996, :rank=>99999999}, {:id=>997, :rank=>99999999}, {:id=>999, :rank=>99999999}, {:id=>1000, :rank=>99999999}, {:id=>1001, :rank=>99999999}, {:id=>1002, :rank=>99999999}, {:id=>1003, :rank=>99999999}, {:id=>1004, :rank=>99999999}, {:id=>1005, :rank=>99999999}, {:id=>1006, :rank=>99999999}, {:id=>1007, :rank=>99999999}, {:id=>1008, :rank=>99999999}, {:id=>1009, :rank=>99999999}, {:id=>1010, :rank=>99999999}, {:id=>1011, :rank=>99999999}, {:id=>1012, :rank=>99999999}, {:id=>1013, :rank=>99999999}, {:id=>1014, :rank=>99999999}, {:id=>1016, :rank=>99999999}, {:id=>1017, :rank=>99999999}, {:id=>1018, :rank=>99999999}, {:id=>1019, :rank=>99999999}, {:id=>1020, :rank=>99999999}, {:id=>1021, :rank=>99999999}, {:id=>1022, :rank=>99999999}, {:id=>1023, :rank=>99999999}, {:id=>1024, :rank=>99999999}, {:id=>1025, :rank=>99999999}, {:id=>1026, :rank=>99999999}, {:id=>1027, :rank=>99999999}, {:id=>1028, :rank=>99999999}, {:id=>1029, :rank=>99999999}, {:id=>1030, :rank=>99999999}, {:id=>1031, :rank=>99999999}, {:id=>1033, :rank=>99999999}, {:id=>1034, :rank=>99999999}, {:id=>1035, :rank=>99999999}, {:id=>1036, :rank=>99999999}, {:id=>1037, :rank=>99999999}, {:id=>1038, :rank=>99999999}, {:id=>1039, :rank=>99999999}, {:id=>1040, :rank=>99999999}, {:id=>1041, :rank=>99999999}, {:id=>1042, :rank=>99999999}, {:id=>1043, :rank=>99999999}, {:id=>1044, :rank=>99999999}, {:id=>1045, :rank=>99999999}, {:id=>1046, :rank=>99999999}, {:id=>1047, :rank=>99999999}, {:id=>1048, :rank=>99999999}, {:id=>1050, :rank=>99999999}, {:id=>1051, :rank=>99999999}, {:id=>1052, :rank=>99999999}, {:id=>1053, :rank=>99999999}, {:id=>1054, :rank=>99999999}, {:id=>1055, :rank=>99999999}, {:id=>1056, :rank=>99999999}, {:id=>1057, :rank=>99999999}, {:id=>1058, :rank=>99999999}, {:id=>1059, :rank=>99999999}, {:id=>1060, :rank=>99999999}, {:id=>1061, :rank=>99999999}, {:id=>1062, :rank=>99999999}, {:id=>1063, :rank=>99999999}, {:id=>1064, :rank=>99999999}, {:id=>1065, :rank=>99999999}, {:id=>1067, :rank=>99999999}, {:id=>1068, :rank=>99999999}, {:id=>1069, :rank=>99999999}, {:id=>1070, :rank=>99999999}, {:id=>1071, :rank=>99999999}, {:id=>1072, :rank=>99999999}, {:id=>1073, :rank=>99999999}, {:id=>1074, :rank=>99999999}, {:id=>1075, :rank=>99999999}, {:id=>1076, :rank=>99999999}, {:id=>1077, :rank=>99999999}, {:id=>1078, :rank=>99999999}, {:id=>1079, :rank=>99999999}, {:id=>1080, :rank=>1}, {:id=>1082, :rank=>1}, {:id=>1083, :rank=>2}, {:id=>1085, :rank=>2}, {:id=>1086, :rank=>3}, {:id=>1087, :rank=>6}, {:id=>1088, :rank=>9}, {:id=>1089, :rank=>10}, {:id=>1090, :rank=>5}, {:id=>1091, :rank=>8}, {:id=>1092, :rank=>7}, {:id=>1093, :rank=>3}, {:id=>1094, :rank=>1}, {:id=>1095, :rank=>2}, {:id=>1096, :rank=>4}, {:id=>1097, :rank=>5}, {:id=>1098, :rank=>10}, {:id=>1099, :rank=>9}, {:id=>1100, :rank=>24}, {:id=>1102, :rank=>14}, {:id=>1103, :rank=>29}, {:id=>1104, :rank=>19}, {:id=>1105, :rank=>13}, {:id=>1106, :rank=>23}, {:id=>1107, :rank=>27}, {:id=>1108, :rank=>15}, {:id=>1109, :rank=>12}, {:id=>1110, :rank=>18}, {:id=>1111, :rank=>22}, {:id=>1112, :rank=>7}, {:id=>1113, :rank=>17}, {:id=>1114, :rank=>26}, {:id=>1115, :rank=>8}, {:id=>1116, :rank=>21}, {:id=>1117, :rank=>16}, {:id=>1119, :rank=>20}, {:id=>1120, :rank=>30}, {:id=>1121, :rank=>35}, {:id=>1122, :rank=>42}, {:id=>1123, :rank=>36}, {:id=>1124, :rank=>41}, {:id=>1125, :rank=>34}, {:id=>1126, :rank=>40}, {:id=>1127, :rank=>33}, {:id=>1128, :rank=>39}, {:id=>1129, :rank=>44}, {:id=>1130, :rank=>32}, {:id=>1131, :rank=>38}, {:id=>1132, :rank=>31}, {:id=>1133, :rank=>43}, {:id=>1134, :rank=>37}, {:id=>1136, :rank=>6}, {:id=>1137, :rank=>3}, {:id=>1138, :rank=>4}, {:id=>1139, :rank=>5}, {:id=>1140, :rank=>3}, {:id=>1141, :rank=>8}, {:id=>1142, :rank=>9}, {:id=>1143, :rank=>10}, {:id=>1144, :rank=>1}, {:id=>1145, :rank=>12}, {:id=>1146, :rank=>13}, {:id=>1147, :rank=>1}, {:id=>1148, :rank=>2}, {:id=>1149, :rank=>3}, {:id=>1150, :rank=>4}, {:id=>1151, :rank=>5}, {:id=>1153, :rank=>7}, {:id=>1154, :rank=>8}, {:id=>1155, :rank=>10}, {:id=>1156, :rank=>11}, {:id=>1157, :rank=>12}, {:id=>1158, :rank=>13}, {:id=>1159, :rank=>14}, {:id=>1160, :rank=>15}, {:id=>1161, :rank=>18}, {:id=>1162, :rank=>16}, {:id=>1163, :rank=>17}, {:id=>1164, :rank=>19}, {:id=>1165, :rank=>20}, {:id=>1166, :rank=>21}, {:id=>1167, :rank=>22}, {:id=>1168, :rank=>23}, {:id=>1170, :rank=>25}, {:id=>1171, :rank=>26}, {:id=>1172, :rank=>99999999}, {:id=>1173, :rank=>99999999}, {:id=>1174, :rank=>99999999}, {:id=>1175, :rank=>99999999}, {:id=>1176, :rank=>99999999}, {:id=>1177, :rank=>99999999}, {:id=>1178, :rank=>99999999}, {:id=>1179, :rank=>99999999}, {:id=>1180, :rank=>99999999}, {:id=>1181, :rank=>99999999}, {:id=>1182, :rank=>99999999}, {:id=>1183, :rank=>99999999}, {:id=>1184, :rank=>99999999}, {:id=>1185, :rank=>99999999}, {:id=>1187, :rank=>99999999}, {:id=>1188, :rank=>99999999}, {:id=>1189, :rank=>99999999}, {:id=>1190, :rank=>99999999}, {:id=>1191, :rank=>99999999}, {:id=>1192, :rank=>99999999}, {:id=>1193, :rank=>99999999}, {:id=>1194, :rank=>99999999}, {:id=>1195, :rank=>99999999}, {:id=>1196, :rank=>1}, {:id=>1197, :rank=>2}, {:id=>1198, :rank=>99999999}, {:id=>1199, :rank=>99999999}, {:id=>1200, :rank=>99999999}, {:id=>1202, :rank=>99999999}, {:id=>1203, :rank=>99999999}, {:id=>1205, :rank=>99999999}, {:id=>1206, :rank=>99999999}, {:id=>1207, :rank=>99999999}, {:id=>1208, :rank=>99999999}, {:id=>1209, :rank=>99999999}, {:id=>1210, :rank=>99999999}, {:id=>1211, :rank=>99999999}, {:id=>1212, :rank=>99999999}, {:id=>1213, :rank=>99999999}, {:id=>1214, :rank=>99999999}, {:id=>1215, :rank=>99999999}, {:id=>1216, :rank=>99999999}, {:id=>1217, :rank=>99999999}, {:id=>1218, :rank=>99999999}, {:id=>1219, :rank=>99999999}, {:id=>1220, :rank=>99999999}, {:id=>1222, :rank=>99999999}, {:id=>1223, :rank=>99999999}, {:id=>1224, :rank=>99999999}, {:id=>1225, :rank=>99999999}, {:id=>1226, :rank=>99999999}, {:id=>1227, :rank=>99999999}, {:id=>1228, :rank=>99999999}, {:id=>1229, :rank=>99999999}, {:id=>1230, :rank=>99999999}, {:id=>1231, :rank=>99999999}, {:id=>1232, :rank=>99999999}, {:id=>1233, :rank=>99999999}, {:id=>1234, :rank=>99999999}, {:id=>1235, :rank=>99999999}, {:id=>1236, :rank=>99999999}, {:id=>1237, :rank=>99999999}, {:id=>1239, :rank=>99999999}, {:id=>1240, :rank=>99999999}, {:id=>1241, :rank=>99999999}, {:id=>1242, :rank=>99999999}, {:id=>1243, :rank=>99999999}, {:id=>1244, :rank=>99999999}, {:id=>1245, :rank=>99999999}, {:id=>1246, :rank=>99999999}, {:id=>1247, :rank=>99999999}, {:id=>1248, :rank=>99999999}, {:id=>1249, :rank=>99999999}, {:id=>1250, :rank=>99999999}, {:id=>1251, :rank=>99999999}, {:id=>1252, :rank=>99999999}, {:id=>1253, :rank=>99999999}, {:id=>1254, :rank=>99999999}, {:id=>1256, :rank=>99999999}, {:id=>1257, :rank=>99999999}, {:id=>1258, :rank=>99999999}, {:id=>1259, :rank=>99999999}, {:id=>1260, :rank=>99999999}, {:id=>1261, :rank=>99999999}, {:id=>1262, :rank=>99999999}, {:id=>1263, :rank=>99999999}, {:id=>1264, :rank=>99999999}, {:id=>1265, :rank=>99999999}, {:id=>1266, :rank=>99999999}, {:id=>1267, :rank=>99999999}, {:id=>1268, :rank=>99999999}, {:id=>1269, :rank=>99999999}, {:id=>1270, :rank=>99999999}, {:id=>1271, :rank=>99999999}, {:id=>1273, :rank=>99999999}, {:id=>1274, :rank=>99999999}, {:id=>1275, :rank=>99999999}, {:id=>1276, :rank=>99999999}, {:id=>1277, :rank=>99999999}, {:id=>1278, :rank=>99999999}, {:id=>1279, :rank=>99999999}, {:id=>1280, :rank=>99999999}, {:id=>1281, :rank=>99999999}, {:id=>1282, :rank=>99999999}, {:id=>1283, :rank=>99999999}, {:id=>1284, :rank=>99999999}, {:id=>1285, :rank=>99999999}, {:id=>1286, :rank=>99999999}, {:id=>1287, :rank=>99999999}, {:id=>1288, :rank=>99999999}, {:id=>1290, :rank=>99999999}, {:id=>1291, :rank=>99999999}, {:id=>1292, :rank=>99999999}, {:id=>1293, :rank=>99999999}, {:id=>1294, :rank=>99999999}, {:id=>1295, :rank=>99999999}, {:id=>1296, :rank=>99999999}, {:id=>1297, :rank=>99999999}, {:id=>1298, :rank=>99999999}, {:id=>1299, :rank=>99999999}, {:id=>1300, :rank=>99999999}, {:id=>1301, :rank=>99999999}, {:id=>1302, :rank=>99999999}, {:id=>1303, :rank=>99999999}, {:id=>1304, :rank=>99999999}, {:id=>1305, :rank=>99999999}, {:id=>1307, :rank=>99999999}, {:id=>1308, :rank=>99999999}, {:id=>1309, :rank=>99999999}, {:id=>1310, :rank=>99999999}, {:id=>1311, :rank=>99999999}, {:id=>1312, :rank=>99999999}, {:id=>1313, :rank=>99999999}, {:id=>1314, :rank=>99999999}, {:id=>1315, :rank=>99999999}, {:id=>1316, :rank=>99999999}, {:id=>1317, :rank=>99999999}, {:id=>1318, :rank=>99999999}, {:id=>1319, :rank=>99999999}, {:id=>1320, :rank=>99999999}, {:id=>1322, :rank=>99999999}, {:id=>1323, :rank=>99999999}, {:id=>1325, :rank=>99999999}, {:id=>1326, :rank=>99999999}, {:id=>1327, :rank=>99999999}, {:id=>1328, :rank=>99999999}, {:id=>1329, :rank=>99999999}, {:id=>1330, :rank=>99999999}, {:id=>1331, :rank=>99999999}, {:id=>1332, :rank=>99999999}, {:id=>1333, :rank=>99999999}, {:id=>1334, :rank=>99999999}, {:id=>1335, :rank=>99999999}, {:id=>1336, :rank=>99999999}, {:id=>1337, :rank=>99999999}, {:id=>1338, :rank=>99999999}, {:id=>1339, :rank=>99999999}, {:id=>1340, :rank=>99999999}, {:id=>1342, :rank=>99999999}, {:id=>1343, :rank=>99999999}, {:id=>1344, :rank=>99999999}, {:id=>1345, :rank=>99999999}, {:id=>1346, :rank=>99999999}, {:id=>1347, :rank=>99999999}, {:id=>1348, :rank=>99999999}, {:id=>1349, :rank=>99999999}, {:id=>1350, :rank=>99999999}, {:id=>1351, :rank=>99999999}, {:id=>1352, :rank=>99999999}, {:id=>1353, :rank=>99999999}, {:id=>1354, :rank=>99999999}, {:id=>1355, :rank=>99999999}, {:id=>1356, :rank=>99999999}, {:id=>1357, :rank=>99999999}, {:id=>1359, :rank=>99999999}, {:id=>1360, :rank=>99999999}, {:id=>1361, :rank=>99999999}, {:id=>1362, :rank=>99999999}, {:id=>1363, :rank=>99999999}, {:id=>1364, :rank=>99999999}, {:id=>1365, :rank=>99999999}, {:id=>1366, :rank=>99999999}, {:id=>1367, :rank=>99999999}, {:id=>1368, :rank=>99999999}, {:id=>1369, :rank=>99999999}, {:id=>1370, :rank=>99999999}, {:id=>1371, :rank=>99999999}, {:id=>1372, :rank=>99999999}, {:id=>1373, :rank=>99999999}, {:id=>1374, :rank=>99999999}, {:id=>1376, :rank=>99999999}, {:id=>1377, :rank=>99999999}, {:id=>1378, :rank=>99999999}, {:id=>1379, :rank=>99999999}, {:id=>1380, :rank=>99999999}, {:id=>1381, :rank=>99999999}, {:id=>1382, :rank=>99999999}, {:id=>1383, :rank=>99999999}, {:id=>1384, :rank=>99999999}, {:id=>1385, :rank=>99999999}, {:id=>1386, :rank=>99999999}, {:id=>1387, :rank=>99999999}, {:id=>1388, :rank=>99999999}, {:id=>1389, :rank=>99999999}, {:id=>1390, :rank=>99999999}, {:id=>1391, :rank=>99999999}, {:id=>1393, :rank=>99999999}, {:id=>1394, :rank=>99999999}, {:id=>1395, :rank=>99999999}, {:id=>1396, :rank=>99999999}, {:id=>1397, :rank=>99999999}, {:id=>1398, :rank=>99999999}, {:id=>1399, :rank=>99999999}, {:id=>1400, :rank=>99999999}, {:id=>1401, :rank=>99999999}, {:id=>1402, :rank=>99999999}, {:id=>1403, :rank=>99999999}, {:id=>1404, :rank=>99999999}, {:id=>1405, :rank=>99999999}, {:id=>1406, :rank=>99999999}, {:id=>1407, :rank=>99999999}, {:id=>1408, :rank=>99999999}, {:id=>1410, :rank=>99999999}, {:id=>1411, :rank=>99999999}, {:id=>1412, :rank=>99999999}, {:id=>1413, :rank=>99999999}, {:id=>1414, :rank=>99999999}, {:id=>1415, :rank=>99999999}, {:id=>1416, :rank=>99999999}, {:id=>1417, :rank=>99999999}, {:id=>1418, :rank=>99999999}, {:id=>1419, :rank=>99999999}, {:id=>1420, :rank=>99999999}, {:id=>1421, :rank=>99999999}, {:id=>1422, :rank=>99999999}, {:id=>1423, :rank=>99999999}, {:id=>1424, :rank=>99999999}, {:id=>1425, :rank=>99999999}, {:id=>1427, :rank=>99999999}, {:id=>1428, :rank=>99999999}, {:id=>1429, :rank=>99999999}, {:id=>1430, :rank=>99999999}, {:id=>1431, :rank=>99999999}, {:id=>1432, :rank=>99999999}, {:id=>1433, :rank=>99999999}, {:id=>1434, :rank=>99999999}, {:id=>1435, :rank=>99999999}, {:id=>1436, :rank=>99999999}, {:id=>1437, :rank=>99999999}, {:id=>1438, :rank=>99999999}, {:id=>1439, :rank=>99999999}, {:id=>1440, :rank=>99999999}, {:id=>1442, :rank=>99999999}, {:id=>1443, :rank=>99999999}, {:id=>1445, :rank=>99999999}, {:id=>1446, :rank=>99999999}, {:id=>1447, :rank=>99999999}, {:id=>1448, :rank=>99999999}, {:id=>1449, :rank=>99999999}, {:id=>1450, :rank=>99999999}, {:id=>1451, :rank=>99999999}, {:id=>1452, :rank=>99999999}, {:id=>1453, :rank=>99999999}, {:id=>1454, :rank=>99999999}, {:id=>1455, :rank=>99999999}, {:id=>1456, :rank=>99999999}, {:id=>1457, :rank=>99999999}, {:id=>1458, :rank=>99999999}, {:id=>1459, :rank=>99999999}, {:id=>1460, :rank=>99999999}, {:id=>1462, :rank=>99999999}, {:id=>1463, :rank=>99999999}, {:id=>1464, :rank=>99999999}, {:id=>1465, :rank=>99999999}, {:id=>1466, :rank=>99999999}, {:id=>1467, :rank=>99999999}, {:id=>1468, :rank=>99999999}, {:id=>1469, :rank=>99999999}, {:id=>1470, :rank=>99999999}, {:id=>1471, :rank=>99999999}, {:id=>1472, :rank=>99999999}, {:id=>1473, :rank=>99999999}, {:id=>1474, :rank=>99999999}, {:id=>1475, :rank=>99999999}, {:id=>1476, :rank=>99999999}, {:id=>1477, :rank=>99999999}, {:id=>1479, :rank=>99999999}, {:id=>1480, :rank=>99999999}, {:id=>1481, :rank=>99999999}, {:id=>1482, :rank=>99999999}, {:id=>1483, :rank=>99999999}, {:id=>1484, :rank=>99999999}, {:id=>1485, :rank=>99999999}, {:id=>1486, :rank=>99999999}, {:id=>1487, :rank=>99999999}, {:id=>1488, :rank=>99999999}, {:id=>1489, :rank=>99999999}, {:id=>1490, :rank=>99999999}, {:id=>1491, :rank=>99999999}, {:id=>1492, :rank=>99999999}, {:id=>1493, :rank=>99999999}, {:id=>1494, :rank=>99999999}, {:id=>1496, :rank=>99999999}, {:id=>1497, :rank=>99999999}, {:id=>1498, :rank=>99999999}, {:id=>1499, :rank=>99999999}, {:id=>1500, :rank=>99999999}, {:id=>1501, :rank=>99999999}, {:id=>1502, :rank=>99999999}, {:id=>1503, :rank=>99999999}, {:id=>1504, :rank=>99999999}, {:id=>1505, :rank=>99999999}, {:id=>1506, :rank=>99999999}, {:id=>1507, :rank=>99999999}, {:id=>1508, :rank=>99999999}, {:id=>1509, :rank=>99999999}, {:id=>1510, :rank=>99999999}, {:id=>1511, :rank=>99999999}, {:id=>1513, :rank=>99999999}, {:id=>1514, :rank=>99999999}, {:id=>1515, :rank=>99999999}, {:id=>1516, :rank=>99999999}, {:id=>1517, :rank=>99999999}, {:id=>1518, :rank=>99999999}, {:id=>1519, :rank=>99999999}, {:id=>1520, :rank=>99999999}, {:id=>1521, :rank=>99999999}, {:id=>1522, :rank=>99999999}, {:id=>1523, :rank=>99999999}, {:id=>1524, :rank=>99999999}, {:id=>1525, :rank=>99999999}, {:id=>1526, :rank=>99999999}, {:id=>1527, :rank=>99999999}, {:id=>1528, :rank=>99999999}, {:id=>1530, :rank=>99999999}, {:id=>1531, :rank=>99999999}, {:id=>1532, :rank=>99999999}, {:id=>1533, :rank=>99999999}, {:id=>1534, :rank=>99999999}, {:id=>1535, :rank=>99999999}, {:id=>1536, :rank=>99999999}, {:id=>1537, :rank=>99999999}, {:id=>1538, :rank=>99999999}, {:id=>1539, :rank=>99999999}, {:id=>1540, :rank=>99999999}, {:id=>1541, :rank=>99999999}, {:id=>1542, :rank=>99999999}, {:id=>1543, :rank=>99999999}, {:id=>1544, :rank=>99999999}, {:id=>1545, :rank=>99999999}, {:id=>1547, :rank=>99999999}, {:id=>1548, :rank=>99999999}, {:id=>1549, :rank=>99999999}, {:id=>1550, :rank=>99999999}, {:id=>1551, :rank=>99999999}, {:id=>1552, :rank=>99999999}, {:id=>1553, :rank=>99999999}, {:id=>1554, :rank=>99999999}, {:id=>1555, :rank=>99999999}, {:id=>1556, :rank=>99999999}, {:id=>1557, :rank=>99999999}, {:id=>1558, :rank=>99999999}, {:id=>1559, :rank=>99999999}, {:id=>1560, :rank=>99999999}, {:id=>1562, :rank=>99999999}, {:id=>1563, :rank=>99999999}, {:id=>1565, :rank=>99999999}, {:id=>1566, :rank=>99999999}, {:id=>1567, :rank=>99999999}, {:id=>1568, :rank=>99999999}, {:id=>1569, :rank=>99999999}, {:id=>1570, :rank=>99999999}, {:id=>1571, :rank=>99999999}, {:id=>1572, :rank=>99999999}, {:id=>1573, :rank=>99999999}, {:id=>1574, :rank=>99999999}, {:id=>1575, :rank=>99999999}, {:id=>1576, :rank=>99999999}, {:id=>1577, :rank=>99999999}, {:id=>1578, :rank=>99999999}, {:id=>1579, :rank=>99999999}, {:id=>1580, :rank=>99999999}, {:id=>1582, :rank=>99999999}, {:id=>1583, :rank=>99999999}, {:id=>1584, :rank=>99999999}, {:id=>1585, :rank=>99999999}, {:id=>1586, :rank=>99999999}, {:id=>1587, :rank=>99999999}, {:id=>1588, :rank=>99999999}, {:id=>1589, :rank=>99999999}, {:id=>1590, :rank=>99999999}, {:id=>1591, :rank=>99999999}, {:id=>1592, :rank=>99999999}, {:id=>1593, :rank=>99999999}, {:id=>1594, :rank=>99999999}, {:id=>1595, :rank=>99999999}, {:id=>1596, :rank=>99999999}, {:id=>1597, :rank=>99999999}, {:id=>1599, :rank=>99999999}, {:id=>1600, :rank=>99999999}, {:id=>1601, :rank=>99999999}, {:id=>1602, :rank=>99999999}, {:id=>1603, :rank=>99999999}, {:id=>1604, :rank=>99999999}, {:id=>1605, :rank=>99999999}, {:id=>1606, :rank=>99999999}, {:id=>1607, :rank=>99999999}, {:id=>1608, :rank=>99999999}, {:id=>1609, :rank=>99999999}, {:id=>1610, :rank=>99999999}, {:id=>1611, :rank=>99999999}, {:id=>1612, :rank=>99999999}, {:id=>1613, :rank=>99999999}, {:id=>1614, :rank=>99999999}, {:id=>1616, :rank=>99999999}, {:id=>1617, :rank=>99999999}, {:id=>1618, :rank=>99999999}, {:id=>1619, :rank=>99999999}, {:id=>1620, :rank=>99999999}, {:id=>1621, :rank=>99999999}, {:id=>1622, :rank=>99999999}, {:id=>1623, :rank=>99999999}, {:id=>1624, :rank=>99999999}, {:id=>1625, :rank=>99999999}, {:id=>1626, :rank=>99999999}, {:id=>1627, :rank=>99999999}, {:id=>1628, :rank=>99999999}, {:id=>1629, :rank=>99999999}, {:id=>1630, :rank=>99999999}, {:id=>1631, :rank=>99999999}, {:id=>1633, :rank=>1}, {:id=>1634, :rank=>4}, {:id=>1635, :rank=>4}, {:id=>1636, :rank=>5}, {:id=>1637, :rank=>6}, {:id=>1638, :rank=>6}, {:id=>1639, :rank=>3}, {:id=>1640, :rank=>7}, {:id=>1641, :rank=>7}, {:id=>1642, :rank=>7}, {:id=>1643, :rank=>10}, {:id=>1644, :rank=>7}, {:id=>1645, :rank=>7}, {:id=>1646, :rank=>8}, {:id=>1647, :rank=>99999999}, {:id=>1648, :rank=>99999999}, {:id=>1650, :rank=>99999999}, {:id=>1651, :rank=>99999999}, {:id=>1652, :rank=>99999999}, {:id=>1653, :rank=>99999999}, {:id=>1654, :rank=>99999999}, {:id=>1655, :rank=>99999999}, {:id=>1656, :rank=>99999999}, {:id=>1657, :rank=>99999999}, {:id=>1658, :rank=>99999999}, {:id=>1659, :rank=>99999999}, {:id=>1660, :rank=>99999999}, {:id=>1661, :rank=>99999999}, {:id=>1662, :rank=>99999999}, {:id=>1663, :rank=>99999999}, {:id=>1664, :rank=>99999999}, {:id=>1665, :rank=>1}, {:id=>1667, :rank=>3}, {:id=>1668, :rank=>4}, {:id=>1669, :rank=>5}, {:id=>1670, :rank=>6}, {:id=>1671, :rank=>7}, {:id=>1672, :rank=>8}, {:id=>1673, :rank=>10}, {:id=>1674, :rank=>4}, {:id=>1675, :rank=>11}, {:id=>1676, :rank=>5}, {:id=>1677, :rank=>1}, {:id=>1678, :rank=>6}, {:id=>1679, :rank=>2}, {:id=>1680, :rank=>3}, {:id=>1682, :rank=>7}, {:id=>1683, :rank=>8}, {:id=>1685, :rank=>9}, {:id=>1686, :rank=>10}, {:id=>1687, :rank=>11}, {:id=>1688, :rank=>12}, {:id=>1689, :rank=>13}, {:id=>1690, :rank=>14}, {:id=>1691, :rank=>15}, {:id=>1692, :rank=>16}, {:id=>1693, :rank=>17}, {:id=>1694, :rank=>18}, {:id=>1695, :rank=>19}, {:id=>1696, :rank=>20}, {:id=>1697, :rank=>21}, {:id=>1698, :rank=>22}, {:id=>1699, :rank=>23}, {:id=>1700, :rank=>24}, {:id=>1702, :rank=>26}, {:id=>1703, :rank=>27}, {:id=>1704, :rank=>28}, {:id=>1705, :rank=>29}, {:id=>1706, :rank=>30}, {:id=>1707, :rank=>31}, {:id=>1708, :rank=>32}, {:id=>1709, :rank=>33}, {:id=>1710, :rank=>34}, {:id=>1711, :rank=>35}, {:id=>1712, :rank=>36}, {:id=>1713, :rank=>37}, {:id=>1714, :rank=>38}, {:id=>1715, :rank=>99999999}, {:id=>1716, :rank=>99999999}, {:id=>1717, :rank=>7}, {:id=>1719, :rank=>99999999}, {:id=>1720, :rank=>99999999}, {:id=>1721, :rank=>99999999}, {:id=>1722, :rank=>99999999}, {:id=>1723, :rank=>99999999}, {:id=>1724, :rank=>99999999}, {:id=>1725, :rank=>99999999}, {:id=>1726, :rank=>4}, {:id=>1727, :rank=>7}, {:id=>1728, :rank=>10}, {:id=>1729, :rank=>7}, {:id=>1730, :rank=>5}, {:id=>1731, :rank=>3}, {:id=>1732, :rank=>7}, {:id=>1733, :rank=>7}, {:id=>1734, :rank=>7}, {:id=>1736, :rank=>7}, {:id=>1737, :rank=>8}, {:id=>1738, :rank=>6}, {:id=>1739, :rank=>1}, {:id=>1740, :rank=>9}, {:id=>1741, :rank=>99999999}, {:id=>1742, :rank=>99999999}, {:id=>1743, :rank=>99999999}, {:id=>1744, :rank=>99999999}, {:id=>1745, :rank=>99999999}, {:id=>1746, :rank=>99999999}, {:id=>1747, :rank=>99999999}, {:id=>1748, :rank=>99999999}, {:id=>1749, :rank=>99999999}, {:id=>1750, :rank=>99999999}, {:id=>1751, :rank=>99999999}, {:id=>1753, :rank=>99999999}, {:id=>1754, :rank=>99999999}, {:id=>1755, :rank=>1}, {:id=>1756, :rank=>4}, {:id=>1757, :rank=>10}, {:id=>1758, :rank=>2}, {:id=>1759, :rank=>3}, {:id=>1760, :rank=>2}, {:id=>1761, :rank=>3}, {:id=>1762, :rank=>99999999}, {:id=>1763, :rank=>99999999}, {:id=>1764, :rank=>99999999}, {:id=>1765, :rank=>11}, {:id=>1766, :rank=>1}, {:id=>1767, :rank=>2}, {:id=>1768, :rank=>3}, {:id=>1770, :rank=>5}, {:id=>1771, :rank=>7}, {:id=>1772, :rank=>8}, {:id=>1773, :rank=>8}, {:id=>1774, :rank=>9}, {:id=>1775, :rank=>10}, {:id=>1776, :rank=>11}, {:id=>1777, :rank=>12}, {:id=>1778, :rank=>13}, {:id=>1779, :rank=>14}, {:id=>1780, :rank=>15}, {:id=>1781, :rank=>17}, {:id=>1782, :rank=>18}, {:id=>1783, :rank=>11}, {:id=>1784, :rank=>99999999}, {:id=>1785, :rank=>99999999}, {:id=>1787, :rank=>99999999}, {:id=>1788, :rank=>99999999}, {:id=>1789, :rank=>99999999}, {:id=>1790, :rank=>99999999}, {:id=>1791, :rank=>99999999}, {:id=>1792, :rank=>99999999}, {:id=>1793, :rank=>1}, {:id=>1794, :rank=>2}, {:id=>1795, :rank=>1}, {:id=>1796, :rank=>2}, {:id=>1797, :rank=>1}, {:id=>1798, :rank=>2}, {:id=>1799, :rank=>1}, {:id=>1800, :rank=>2}, {:id=>1802, :rank=>2}, {:id=>1803, :rank=>1}, {:id=>1805, :rank=>1}, {:id=>1806, :rank=>2}, {:id=>1807, :rank=>1}, {:id=>1808, :rank=>2}, {:id=>1809, :rank=>1}, {:id=>1810, :rank=>2}, {:id=>1811, :rank=>1}, {:id=>1812, :rank=>2}, {:id=>1813, :rank=>1}, {:id=>1814, :rank=>2}, {:id=>1815, :rank=>1}, {:id=>1816, :rank=>2}, {:id=>1817, :rank=>1}, {:id=>1818, :rank=>2}, {:id=>1819, :rank=>1}, {:id=>1820, :rank=>2}, {:id=>1822, :rank=>2}, {:id=>1823, :rank=>1}, {:id=>1824, :rank=>2}, {:id=>1825, :rank=>1}, {:id=>1826, :rank=>2}, {:id=>1827, :rank=>1}, {:id=>1828, :rank=>2}, {:id=>1829, :rank=>1}, {:id=>1830, :rank=>2}, {:id=>1831, :rank=>1}, {:id=>1832, :rank=>2}, {:id=>1833, :rank=>1}, {:id=>1834, :rank=>2}, {:id=>1835, :rank=>1}, {:id=>1836, :rank=>2}, {:id=>1837, :rank=>1}, {:id=>1839, :rank=>2}, {:id=>1840, :rank=>1}, {:id=>1841, :rank=>2}, {:id=>1842, :rank=>99999999}, {:id=>1843, :rank=>99999999}, {:id=>1844, :rank=>99999999}, {:id=>1845, :rank=>99999999}, {:id=>1846, :rank=>99999999}, {:id=>1847, :rank=>99999999}, {:id=>1848, :rank=>99999999}, {:id=>1849, :rank=>1}, {:id=>1850, :rank=>99999999}, {:id=>1851, :rank=>4}, {:id=>1852, :rank=>99999999}, {:id=>1853, :rank=>99999999}, {:id=>1854, :rank=>99999999}, {:id=>1856, :rank=>3}, {:id=>1857, :rank=>3}, {:id=>1858, :rank=>3}, {:id=>1859, :rank=>4}, {:id=>1860, :rank=>4}, {:id=>1861, :rank=>6}, {:id=>1862, :rank=>7}, {:id=>1863, :rank=>99999999}, {:id=>1864, :rank=>9}, {:id=>1865, :rank=>10}, {:id=>1866, :rank=>5}, {:id=>1867, :rank=>5}, {:id=>1868, :rank=>8}, {:id=>1869, :rank=>28}, {:id=>1870, :rank=>5}, {:id=>1871, :rank=>7}, {:id=>1873, :rank=>99999999}, {:id=>1874, :rank=>99999999}, {:id=>1875, :rank=>7}, {:id=>1876, :rank=>7}, {:id=>1877, :rank=>10}, {:id=>1878, :rank=>99999999}, {:id=>1879, :rank=>99999999}, {:id=>1880, :rank=>99999999}, {:id=>1881, :rank=>6}, {:id=>1882, :rank=>16}, {:id=>1883, :rank=>1}, {:id=>1884, :rank=>1}, {:id=>1885, :rank=>1}, {:id=>1886, :rank=>1}, {:id=>1887, :rank=>1}, {:id=>1888, :rank=>1}, {:id=>1890, :rank=>1}, {:id=>1891, :rank=>1}, {:id=>1892, :rank=>1}, {:id=>1893, :rank=>1}, {:id=>1894, :rank=>1}, {:id=>1895, :rank=>1}, {:id=>1896, :rank=>1}, {:id=>1897, :rank=>1}, {:id=>1898, :rank=>2}, {:id=>1899, :rank=>3}, {:id=>1900, :rank=>20}, {:id=>1901, :rank=>21}, {:id=>1902, :rank=>22}, {:id=>1903, :rank=>23}, {:id=>1904, :rank=>23}, {:id=>1905, :rank=>4}, {:id=>1907, :rank=>5}, {:id=>1908, :rank=>5}, {:id=>1909, :rank=>5}, {:id=>1910, :rank=>5}, {:id=>1911, :rank=>5}, {:id=>1912, :rank=>1}, {:id=>1913, :rank=>1}, {:id=>1914, :rank=>2}, {:id=>1915, :rank=>2}, {:id=>1916, :rank=>4}, {:id=>1917, :rank=>4}, {:id=>1918, :rank=>5}, {:id=>1919, :rank=>5}, {:id=>1920, :rank=>5}, {:id=>1922, :rank=>5}, {:id=>1923, :rank=>5}, {:id=>1925, :rank=>8}, {:id=>1926, :rank=>10}, {:id=>1927, :rank=>6}, {:id=>1928, :rank=>6}, {:id=>1929, :rank=>6}, {:id=>1930, :rank=>9}, {:id=>1931, :rank=>99999999}, {:id=>1932, :rank=>30}, {:id=>1933, :rank=>1}, {:id=>1934, :rank=>2}, {:id=>1935, :rank=>3}, {:id=>1936, :rank=>4}, {:id=>1937, :rank=>5}, {:id=>1938, :rank=>6}, {:id=>1939, :rank=>7}, {:id=>1940, :rank=>1}, {:id=>1942, :rank=>0}, {:id=>1943, :rank=>1}, {:id=>1944, :rank=>2}, {:id=>1945, :rank=>3}, {:id=>1946, :rank=>4}, {:id=>1947, :rank=>5}, {:id=>1948, :rank=>6}, {:id=>1949, :rank=>7}, {:id=>1950, :rank=>8}, {:id=>1951, :rank=>9}, {:id=>1952, :rank=>1}, {:id=>1953, :rank=>2}, {:id=>1954, :rank=>3}, {:id=>1955, :rank=>4}, {:id=>1956, :rank=>5}, {:id=>1957, :rank=>5}, {:id=>1959, :rank=>8}, {:id=>1960, :rank=>9}, {:id=>1961, :rank=>10}, {:id=>1962, :rank=>11}, {:id=>1963, :rank=>12}, {:id=>1964, :rank=>13}, {:id=>1965, :rank=>14}, {:id=>1966, :rank=>21}, {:id=>1967, :rank=>23}, {:id=>1968, :rank=>24}, {:id=>1969, :rank=>1}, {:id=>1970, :rank=>2}, {:id=>1971, :rank=>3}, {:id=>1972, :rank=>4}, {:id=>1973, :rank=>22}, {:id=>1974, :rank=>21}, {:id=>1976, :rank=>1}, {:id=>1977, :rank=>2}, {:id=>1978, :rank=>3}, {:id=>1979, :rank=>4}, {:id=>1980, :rank=>5}, {:id=>1981, :rank=>6}, {:id=>1982, :rank=>7}, {:id=>1983, :rank=>9}, {:id=>1984, :rank=>8}, {:id=>1985, :rank=>10}, {:id=>1986, :rank=>7}, {:id=>1987, :rank=>7}, {:id=>1988, :rank=>99999999}, {:id=>1989, :rank=>26}, {:id=>1990, :rank=>5}, {:id=>1991, :rank=>5}, {:id=>1993, :rank=>99999999}, {:id=>1994, :rank=>99999999}, {:id=>1995, :rank=>99999999}, {:id=>1996, :rank=>99999999}, {:id=>1997, :rank=>99999999}, {:id=>1998, :rank=>7}, {:id=>1999, :rank=>99999999}, {:id=>2000, :rank=>99999999}, {:id=>2001, :rank=>99999999}, {:id=>2002, :rank=>99999999}, {:id=>2003, :rank=>99999999}, {:id=>2004, :rank=>99999999}, {:id=>2005, :rank=>99999999}, {:id=>2006, :rank=>99999999}, {:id=>2007, :rank=>99999999}, {:id=>2008, :rank=>99999999}, {:id=>2010, :rank=>99999999}, {:id=>2011, :rank=>99999999}, {:id=>2012, :rank=>99999999}, {:id=>2013, :rank=>99999999}, {:id=>2014, :rank=>99999999}, {:id=>2015, :rank=>99999999}, {:id=>2016, :rank=>99999999}, {:id=>2017, :rank=>99999999}, {:id=>2018, :rank=>99999999}, {:id=>2019, :rank=>99999999}, {:id=>2020, :rank=>99999999}, {:id=>2021, :rank=>99999999}, {:id=>2022, :rank=>99999999}, {:id=>2023, :rank=>99999999}, {:id=>2024, :rank=>7}, {:id=>2025, :rank=>7}, {:id=>2027, :rank=>7}, {:id=>2028, :rank=>7}, {:id=>2029, :rank=>99999999}, {:id=>2030, :rank=>1}, {:id=>2031, :rank=>7}, {:id=>2032, :rank=>999999}, {:id=>2033, :rank=>999999}, {:id=>2034, :rank=>999999}, {:id=>2035, :rank=>999999}, {:id=>2036, :rank=>22}, {:id=>2037, :rank=>25}, {:id=>2038, :rank=>99999999}, {:id=>2039, :rank=>99999999}, {:id=>2040, :rank=>99999999}, {:id=>2106, :rank=>nil}, {:id=>2133, :rank=>nil}, {:id=>2042, :rank=>99999999}, {:id=>2043, :rank=>99999999}, {:id=>2045, :rank=>99999999}, {:id=>2046, :rank=>99999999}, {:id=>2047, :rank=>99999999}, {:id=>2048, :rank=>99999999}, {:id=>2049, :rank=>99999999}, {:id=>2050, :rank=>99999999}, {:id=>2051, :rank=>99999999}, {:id=>2052, :rank=>99999999}, {:id=>2053, :rank=>7}, {:id=>2054, :rank=>3}, {:id=>2055, :rank=>7}, {:id=>2056, :rank=>4}, {:id=>2057, :rank=>7}, {:id=>2058, :rank=>7}, {:id=>2059, :rank=>1}, {:id=>2060, :rank=>2}, {:id=>2062, :rank=>9}, {:id=>2063, :rank=>10}, {:id=>2064, :rank=>99999999}, {:id=>2065, :rank=>99999999}, {:id=>2066, :rank=>99999999}, {:id=>2067, :rank=>99999999}, {:id=>2068, :rank=>99999999}, {:id=>2069, :rank=>99999999}, {:id=>2070, :rank=>99999999}, {:id=>2071, :rank=>99999999}, {:id=>2072, :rank=>99999999}, {:id=>2073, :rank=>99999999}, {:id=>2074, :rank=>99999999}, {:id=>2075, :rank=>99999999}, {:id=>2076, :rank=>99999999}, {:id=>2077, :rank=>99999999}, {:id=>2079, :rank=>99999999}, {:id=>2080, :rank=>99999999}, {:id=>2081, :rank=>99999999}, {:id=>2082, :rank=>99999999}, {:id=>2083, :rank=>99999999}, {:id=>2084, :rank=>99999999}, {:id=>2085, :rank=>1}, {:id=>2086, :rank=>1}, {:id=>2087, :rank=>1}, {:id=>2088, :rank=>1}, {:id=>2089, :rank=>7}, {:id=>2090, :rank=>99999999}, {:id=>2091, :rank=>99999999}, {:id=>2092, :rank=>99999999}, {:id=>2093, :rank=>99999999}, {:id=>2094, :rank=>99999999}, {:id=>2096, :rank=>7}, {:id=>2097, :rank=>7}, {:id=>2098, :rank=>99999999}, {:id=>2099, :rank=>99999999}, {:id=>2100, :rank=>9}, {:id=>2101, :rank=>7}, {:id=>2102, :rank=>7}, {:id=>2103, :rank=>7}, {:id=>2104, :rank=>7}, {:id=>2105, :rank=>99999999}, {:id=>2107, :rank=>99999999}, {:id=>2108, :rank=>99999999}, {:id=>2109, :rank=>99999999}, {:id=>2110, :rank=>99999999}, {:id=>2111, :rank=>99999999}, {:id=>2112, :rank=>99999999}, {:id=>2114, :rank=>99999999}, {:id=>2115, :rank=>99999999}, {:id=>2116, :rank=>99999999}, {:id=>2117, :rank=>99999999}, {:id=>2118, :rank=>99999999}, {:id=>2119, :rank=>99999999}, {:id=>2120, :rank=>99999999}, {:id=>2121, :rank=>99999999}, {:id=>2122, :rank=>99999999}, {:id=>2123, :rank=>99999999}, {:id=>2124, :rank=>99999999}, {:id=>2125, :rank=>99999999}, {:id=>2126, :rank=>99999999}, {:id=>2127, :rank=>99999999}, {:id=>2128, :rank=>99999999}, {:id=>2129, :rank=>99999999}, {:id=>2131, :rank=>99999999}, {:id=>2132, :rank=>99999999}, {:id=>2134, :rank=>99999999}, {:id=>2135, :rank=>99999999}, {:id=>2136, :rank=>99999999}, {:id=>2137, :rank=>99999999}, {:id=>2138, :rank=>99999999}, {:id=>2139, :rank=>99999999}, {:id=>2140, :rank=>99999999}, {:id=>2141, :rank=>99999999}, {:id=>2142, :rank=>99999999}, {:id=>2143, :rank=>99999999}, {:id=>2144, :rank=>99999999}, {:id=>2145, :rank=>99999999}, {:id=>2146, :rank=>99999999}, {:id=>2147, :rank=>99999999}, {:id=>2149, :rank=>99999999}, {:id=>2150, :rank=>99999999}, {:id=>2151, :rank=>99999999}, {:id=>2152, :rank=>99999999}, {:id=>2153, :rank=>99999999}, {:id=>2154, :rank=>99999999}, {:id=>2155, :rank=>99999999}, {:id=>2156, :rank=>99999999}, {:id=>2157, :rank=>99999999}, {:id=>2158, :rank=>99999999}, {:id=>2159, :rank=>99999999}, {:id=>2160, :rank=>99999999}, {:id=>2162, :rank=>99999999}, {:id=>2163, :rank=>99999999}, {:id=>2165, :rank=>99999999}, {:id=>2166, :rank=>99999999}, {:id=>2167, :rank=>99999999}, {:id=>2168, :rank=>99999999}, {:id=>2169, :rank=>99999999}, {:id=>2170, :rank=>99999999}, {:id=>2171, :rank=>99999999}, {:id=>2172, :rank=>99999999}, {:id=>2173, :rank=>99999999}, {:id=>2174, :rank=>99999999}, {:id=>2175, :rank=>99999999}, {:id=>2176, :rank=>99999999}, {:id=>2177, :rank=>5}, {:id=>2178, :rank=>99999999}, {:id=>2179, :rank=>2}, {:id=>2180, :rank=>99999999}, {:id=>2182, :rank=>4}, {:id=>2183, :rank=>99999999}, {:id=>2184, :rank=>1}, {:id=>2185, :rank=>4}, {:id=>2186, :rank=>99999999}, {:id=>2187, :rank=>99999999}, {:id=>2188, :rank=>99999999}, {:id=>2189, :rank=>99999999}, {:id=>2190, :rank=>5}, {:id=>2191, :rank=>99999999}, {:id=>2192, :rank=>4}, {:id=>2193, :rank=>99999999}, {:id=>2194, :rank=>99999999}, {:id=>2195, :rank=>8}, {:id=>2196, :rank=>7}, {:id=>2197, :rank=>99999999}, {:id=>2199, :rank=>99999999}, {:id=>2200, :rank=>99999999}, {:id=>2201, :rank=>99999999}, {:id=>2202, :rank=>5}, {:id=>2203, :rank=>99999999}, {:id=>2204, :rank=>1}, {:id=>2205, :rank=>99999999}, {:id=>2206, :rank=>99999999}, {:id=>2207, :rank=>99999999}, {:id=>2208, :rank=>10}, {:id=>2209, :rank=>99999999}, {:id=>2210, :rank=>99999999}, {:id=>2211, :rank=>3}, {:id=>2212, :rank=>5}, {:id=>2213, :rank=>99999999}, {:id=>2214, :rank=>10}, {:id=>2216, :rank=>99999999}, {:id=>2217, :rank=>99999999}, {:id=>2218, :rank=>99999999}, {:id=>2219, :rank=>5}, {:id=>2220, :rank=>99999999}, {:id=>2221, :rank=>10}, {:id=>2222, :rank=>99999999}, {:id=>2223, :rank=>99999999}, {:id=>2224, :rank=>99999999}, {:id=>2225, :rank=>99999999}, {:id=>2226, :rank=>99999999}, {:id=>2227, :rank=>99999999}, {:id=>2228, :rank=>99999999}, {:id=>2229, :rank=>99999999}, {:id=>2230, :rank=>99999999}, {:id=>2231, :rank=>99999999}, {:id=>2233, :rank=>99999999}, {:id=>2234, :rank=>99999999}, {:id=>2235, :rank=>99999999}, {:id=>2236, :rank=>99999999}, {:id=>2237, :rank=>99999999}, {:id=>2238, :rank=>99999999}, {:id=>2239, :rank=>99999999}, {:id=>2240, :rank=>99999999}, {:id=>2241, :rank=>99999999}, {:id=>2242, :rank=>99999999}, {:id=>2243, :rank=>99999999}, {:id=>2244, :rank=>99999999}, {:id=>2245, :rank=>99999999}, {:id=>2246, :rank=>99999999}, {:id=>2247, :rank=>99999999}, {:id=>2248, :rank=>99999999}, {:id=>2250, :rank=>99999999}, {:id=>2251, :rank=>99999999}, {:id=>2252, :rank=>99999999}, {:id=>2253, :rank=>99999999}, {:id=>2254, :rank=>99999999}, {:id=>2255, :rank=>99999999}, {:id=>2256, :rank=>99999999}, {:id=>2257, :rank=>99999999}, {:id=>2258, :rank=>99999999}, {:id=>2259, :rank=>99999999}, {:id=>2260, :rank=>99999999}, {:id=>2261, :rank=>99999999}, {:id=>2262, :rank=>99999999}, {:id=>2263, :rank=>99999999}, {:id=>2264, :rank=>99999999}, {:id=>2265, :rank=>99999999}, {:id=>2267, :rank=>99999999}, {:id=>2268, :rank=>99999999}, {:id=>2269, :rank=>99999999}, {:id=>2270, :rank=>99999999}, {:id=>2271, :rank=>99999999}, {:id=>2272, :rank=>99999999}, {:id=>2273, :rank=>99999999}, {:id=>2274, :rank=>99999999}, {:id=>2275, :rank=>99999999}, {:id=>2276, :rank=>99999999}, {:id=>2277, :rank=>99999999}, {:id=>2278, :rank=>99999999}, {:id=>2279, :rank=>99999999}, {:id=>2280, :rank=>99999999}, {:id=>2282, :rank=>1}, {:id=>2283, :rank=>2}, {:id=>2285, :rank=>6}, {:id=>2286, :rank=>7}, {:id=>2287, :rank=>9}, {:id=>2288, :rank=>10}, {:id=>2289, :rank=>11}, {:id=>2290, :rank=>13}, {:id=>2291, :rank=>14}, {:id=>2292, :rank=>15}, {:id=>2293, :rank=>16}, {:id=>2294, :rank=>17}, {:id=>2295, :rank=>18}, {:id=>2296, :rank=>19}, {:id=>2297, :rank=>20}, {:id=>2298, :rank=>21}, {:id=>2299, :rank=>22}, {:id=>2300, :rank=>24}, {:id=>2302, :rank=>27}, {:id=>2303, :rank=>29}, {:id=>2304, :rank=>31}, {:id=>2305, :rank=>33}, {:id=>2306, :rank=>35}, {:id=>2307, :rank=>37}, {:id=>2308, :rank=>99999999}, {:id=>2309, :rank=>99999999}, {:id=>2310, :rank=>99999999}, {:id=>2311, :rank=>99999999}, {:id=>2312, :rank=>99999999}, {:id=>2313, :rank=>99999999}, {:id=>2314, :rank=>99999999}, {:id=>2315, :rank=>99999999}, {:id=>2316, :rank=>99999999}, {:id=>2317, :rank=>99999999}, {:id=>2319, :rank=>99999999}, {:id=>2320, :rank=>99999999}, {:id=>2321, :rank=>99999999}, {:id=>2322, :rank=>99999999}, {:id=>2323, :rank=>99999999}, {:id=>2324, :rank=>99999999}, {:id=>2325, :rank=>99999999}, {:id=>2326, :rank=>99999999}, {:id=>2327, :rank=>99999999}, {:id=>2328, :rank=>99999999}, {:id=>2329, :rank=>99999999}, {:id=>2330, :rank=>99999999}, {:id=>2331, :rank=>99999999}, {:id=>2332, :rank=>99999999}, {:id=>2333, :rank=>99999999}, {:id=>2334, :rank=>99999999}, {:id=>2336, :rank=>99999999}, {:id=>2337, :rank=>99999999}, {:id=>2338, :rank=>99999999}, {:id=>2339, :rank=>99999999}, {:id=>2340, :rank=>99999999}, {:id=>2341, :rank=>99999999}, {:id=>2342, :rank=>99999999}, {:id=>2343, :rank=>99999999}, {:id=>2344, :rank=>99999999}, {:id=>2345, :rank=>99999999}, {:id=>2346, :rank=>99999999}, {:id=>2347, :rank=>99999999}, {:id=>2348, :rank=>99999999}, {:id=>2349, :rank=>99999999}, {:id=>2350, :rank=>99999999}, {:id=>2351, :rank=>99999999}, {:id=>2353, :rank=>99999999}, {:id=>2354, :rank=>99999999}, {:id=>2355, :rank=>99999999}, {:id=>2356, :rank=>99999999}, {:id=>2357, :rank=>99999999}, {:id=>2358, :rank=>99999999}, {:id=>2359, :rank=>99999999}, {:id=>2360, :rank=>99999999}, {:id=>2361, :rank=>99999999}, {:id=>2362, :rank=>99999999}, {:id=>2363, :rank=>99999999}, {:id=>2364, :rank=>99999999}, {:id=>2365, :rank=>99999999}, {:id=>2366, :rank=>99999999}, {:id=>2367, :rank=>99999999}, {:id=>2368, :rank=>99999999}, {:id=>2370, :rank=>99999999}, {:id=>2371, :rank=>99999999}, {:id=>2372, :rank=>99999999}, {:id=>2373, :rank=>99999999}, {:id=>2374, :rank=>99999999}, {:id=>2375, :rank=>99999999}, {:id=>2376, :rank=>99999999}, {:id=>2377, :rank=>99999999}, {:id=>2378, :rank=>99999999}, {:id=>2379, :rank=>99999999}, {:id=>2380, :rank=>99999999}, {:id=>2381, :rank=>99999999}, {:id=>2382, :rank=>99999999}, {:id=>2383, :rank=>99999999}, {:id=>2384, :rank=>99999999}, {:id=>2385, :rank=>99999999}, {:id=>2387, :rank=>99999999}, {:id=>2388, :rank=>99999999}, {:id=>2389, :rank=>99999999}, {:id=>2390, :rank=>99999999}, {:id=>2391, :rank=>99999999}, {:id=>2392, :rank=>99999999}, {:id=>2393, :rank=>99999999}, {:id=>2394, :rank=>99999999}, {:id=>2395, :rank=>99999999}, {:id=>2396, :rank=>99999999}, {:id=>2397, :rank=>99999999}, {:id=>2398, :rank=>99999999}, {:id=>2399, :rank=>99999999}, {:id=>2400, :rank=>99999999}, {:id=>2402, :rank=>99999999}, {:id=>2403, :rank=>99999999}, {:id=>2405, :rank=>99999999}, {:id=>2406, :rank=>99999999}, {:id=>2407, :rank=>99999999}, {:id=>2408, :rank=>99999999}, {:id=>2409, :rank=>99999999}, {:id=>2410, :rank=>99999999}, {:id=>2411, :rank=>99999999}, {:id=>2412, :rank=>99999999}, {:id=>2413, :rank=>99999999}, {:id=>2414, :rank=>99999999}, {:id=>2415, :rank=>99999999}, {:id=>2416, :rank=>99999999}, {:id=>2417, :rank=>99999999}, {:id=>2418, :rank=>99999999}, {:id=>2419, :rank=>99999999}, {:id=>2420, :rank=>99999999}, {:id=>2422, :rank=>99999999}, {:id=>2423, :rank=>99999999}, {:id=>2424, :rank=>99999999}, {:id=>2425, :rank=>99999999}, {:id=>2426, :rank=>99999999}, {:id=>2427, :rank=>99999999}, {:id=>2428, :rank=>99999999}, {:id=>2429, :rank=>99999999}, {:id=>2430, :rank=>99999999}, {:id=>2431, :rank=>99999999}, {:id=>2432, :rank=>99999999}, {:id=>2433, :rank=>99999999}, {:id=>2434, :rank=>99999999}, {:id=>2435, :rank=>99999999}, {:id=>2436, :rank=>99999999}, {:id=>2437, :rank=>99999999}, {:id=>2439, :rank=>99999999}, {:id=>2440, :rank=>99999999}, {:id=>2441, :rank=>99999999}, {:id=>2442, :rank=>99999999}, {:id=>2443, :rank=>99999999}, {:id=>2444, :rank=>99999999}, {:id=>2445, :rank=>99999999}, {:id=>2446, :rank=>99999999}, {:id=>2447, :rank=>99999999}, {:id=>2448, :rank=>99999999}, {:id=>2449, :rank=>99999999}, {:id=>2450, :rank=>99999999}, {:id=>2451, :rank=>99999999}, {:id=>2452, :rank=>99999999}, {:id=>2453, :rank=>99999999}, {:id=>2454, :rank=>99999999}, {:id=>2456, :rank=>99999999}, {:id=>2457, :rank=>99999999}, {:id=>2458, :rank=>99999999}, {:id=>2459, :rank=>99999999}, {:id=>2460, :rank=>99999999}, {:id=>2461, :rank=>99999999}, {:id=>2462, :rank=>99999999}, {:id=>2463, :rank=>99999999}, {:id=>2464, :rank=>99999999}, {:id=>2465, :rank=>99999999}, {:id=>2466, :rank=>99999999}, {:id=>2467, :rank=>99999999}, {:id=>2468, :rank=>99999999}, {:id=>2469, :rank=>99999999}, {:id=>2470, :rank=>99999999}, {:id=>2471, :rank=>99999999}, {:id=>2473, :rank=>99999999}, {:id=>2474, :rank=>99999999}, {:id=>2475, :rank=>99999999}, {:id=>2476, :rank=>99999999}, {:id=>2477, :rank=>99999999}, {:id=>2478, :rank=>99999999}, {:id=>2479, :rank=>99999999}, {:id=>2480, :rank=>99999999}, {:id=>2481, :rank=>99999999}, {:id=>2482, :rank=>99999999}, {:id=>2483, :rank=>99999999}, {:id=>2484, :rank=>99999999}, {:id=>2485, :rank=>99999999}, {:id=>2486, :rank=>99999999}, {:id=>2487, :rank=>99999999}, {:id=>2488, :rank=>99999999}, {:id=>2490, :rank=>99999999}, {:id=>2491, :rank=>99999999}, {:id=>2492, :rank=>99999999}, {:id=>2493, :rank=>99999999}, {:id=>2494, :rank=>99999999}, {:id=>2495, :rank=>99999999}, {:id=>2496, :rank=>99999999}, {:id=>2497, :rank=>99999999}, {:id=>2498, :rank=>99999999}, {:id=>2499, :rank=>99999999}, {:id=>2500, :rank=>99999999}, {:id=>2501, :rank=>99999999}, {:id=>2502, :rank=>99999999}, {:id=>2503, :rank=>99999999}, {:id=>2504, :rank=>99999999}, {:id=>2505, :rank=>99999999}, {:id=>2507, :rank=>99999999}, {:id=>2508, :rank=>99999999}, {:id=>2509, :rank=>99999999}, {:id=>2510, :rank=>99999999}, {:id=>2511, :rank=>99999999}, {:id=>2512, :rank=>99999999}, {:id=>2513, :rank=>99999999}, {:id=>2514, :rank=>99999999}, {:id=>2515, :rank=>99999999}, {:id=>2516, :rank=>99999999}, {:id=>2517, :rank=>99999999}, {:id=>2518, :rank=>99999999}, {:id=>2519, :rank=>99999999}, {:id=>2520, :rank=>99999999}, {:id=>2576, :rank=>nil}, {:id=>2577, :rank=>nil}, {:id=>2578, :rank=>nil}, {:id=>2579, :rank=>nil}, {:id=>2580, :rank=>nil}, {:id=>2581, :rank=>nil}, {:id=>2582, :rank=>nil}, {:id=>2583, :rank=>nil}, {:id=>2584, :rank=>nil}, {:id=>2585, :rank=>nil}, {:id=>2586, :rank=>nil}, {:id=>2587, :rank=>nil}, {:id=>2588, :rank=>nil}, {:id=>2589, :rank=>nil}, {:id=>2590, :rank=>nil}, {:id=>2591, :rank=>nil}, {:id=>2592, :rank=>nil}, {:id=>2593, :rank=>nil}, {:id=>2594, :rank=>nil}, {:id=>2595, :rank=>nil}, {:id=>2596, :rank=>nil}, {:id=>2597, :rank=>nil}, {:id=>2598, :rank=>nil}, {:id=>2599, :rank=>nil}, {:id=>2600, :rank=>nil}, {:id=>2601, :rank=>nil}, {:id=>2602, :rank=>nil}, {:id=>2603, :rank=>nil}, {:id=>2604, :rank=>nil}, {:id=>2605, :rank=>nil}, {:id=>2606, :rank=>nil}, {:id=>2607, :rank=>nil}, {:id=>2608, :rank=>nil}, {:id=>2609, :rank=>nil}, {:id=>2610, :rank=>nil}, {:id=>2611, :rank=>nil}, {:id=>2612, :rank=>nil}, {:id=>2613, :rank=>nil}, {:id=>2614, :rank=>nil}, {:id=>2615, :rank=>nil}, {:id=>2616, :rank=>nil}, {:id=>2617, :rank=>nil}, {:id=>2618, :rank=>nil}, {:id=>2619, :rank=>nil}, {:id=>2620, :rank=>nil}, {:id=>2621, :rank=>nil}, {:id=>2622, :rank=>nil}, {:id=>2623, :rank=>nil}, {:id=>2624, :rank=>nil}, {:id=>2625, :rank=>nil}, {:id=>2626, :rank=>nil}, {:id=>2627, :rank=>nil}, {:id=>2628, :rank=>nil}, {:id=>2629, :rank=>nil}, {:id=>2630, :rank=>nil}, {:id=>2631, :rank=>nil}, {:id=>2632, :rank=>nil}, {:id=>2633, :rank=>nil}, {:id=>2634, :rank=>nil}, {:id=>2635, :rank=>nil}, {:id=>2636, :rank=>nil}, {:id=>2637, :rank=>nil}, {:id=>2638, :rank=>nil}, {:id=>2639, :rank=>nil}, {:id=>2640, :rank=>nil}, {:id=>2522, :rank=>99999999}, {:id=>2523, :rank=>99999999}, {:id=>2525, :rank=>99999999}, {:id=>2526, :rank=>99999999}, {:id=>2527, :rank=>99999999}, {:id=>2528, :rank=>99999999}, {:id=>2529, :rank=>99999999}, {:id=>2530, :rank=>99999999}, {:id=>2531, :rank=>99999999}, {:id=>2532, :rank=>99999999}, {:id=>2533, :rank=>99999999}, {:id=>2534, :rank=>99999999}, {:id=>2535, :rank=>99999999}, {:id=>2536, :rank=>99999999}, {:id=>2537, :rank=>99999999}, {:id=>2538, :rank=>99999999}, {:id=>2539, :rank=>99999999}, {:id=>2540, :rank=>99999999}, {:id=>2542, :rank=>99999999}, {:id=>2543, :rank=>99999999}, {:id=>2544, :rank=>99999999}, {:id=>2545, :rank=>99999999}, {:id=>2546, :rank=>99999999}, {:id=>2547, :rank=>99999999}, {:id=>2548, :rank=>99999999}, {:id=>2549, :rank=>99999999}, {:id=>2550, :rank=>99999999}, {:id=>2551, :rank=>99999999}, {:id=>2552, :rank=>99999999}, {:id=>2553, :rank=>99999999}, {:id=>2554, :rank=>99999999}, {:id=>2555, :rank=>99999999}, {:id=>2556, :rank=>99999999}, {:id=>2557, :rank=>99999999}, {:id=>2559, :rank=>99999999}, {:id=>2560, :rank=>99999999}, {:id=>2561, :rank=>99999999}, {:id=>2562, :rank=>99999999}, {:id=>2563, :rank=>99999999}, {:id=>2564, :rank=>99999999}, {:id=>2565, :rank=>99999999}, {:id=>2566, :rank=>99999999}, {:id=>2567, :rank=>99999999}, {:id=>2568, :rank=>99999999}, {:id=>2569, :rank=>99999999}, {:id=>2570, :rank=>99999999}, {:id=>2571, :rank=>99999999}, {:id=>2572, :rank=>99999999}, {:id=>2573, :rank=>99999999}, {:id=>2574, :rank=>99999999}, {:id=>2641, :rank=>nil}, {:id=>2642, :rank=>nil}, {:id=>2643, :rank=>nil}, {:id=>2644, :rank=>nil}, {:id=>2645, :rank=>nil}, {:id=>2646, :rank=>nil}, {:id=>2647, :rank=>nil}, {:id=>2648, :rank=>nil}, {:id=>2649, :rank=>nil}, {:id=>2650, :rank=>nil}, {:id=>2651, :rank=>nil}, {:id=>2652, :rank=>nil}, {:id=>2653, :rank=>nil}, {:id=>2654, :rank=>nil}, {:id=>2655, :rank=>nil}, {:id=>2656, :rank=>nil}, {:id=>2657, :rank=>nil}, {:id=>2658, :rank=>nil}, {:id=>1, :rank=>99999999}, {:id=>4, :rank=>99999999}, {:id=>21, :rank=>99999999}, {:id=>38, :rank=>99999999}, {:id=>55, :rank=>99999999}, {:id=>72, :rank=>99999999}, {:id=>89, :rank=>99999999}, {:id=>106, :rank=>99999999}, {:id=>121, :rank=>99999999}, {:id=>124, :rank=>99999999}, {:id=>141, :rank=>99999999}, {:id=>158, :rank=>99999999}, {:id=>175, :rank=>99999999}, {:id=>192, :rank=>99999999}, {:id=>209, :rank=>99999999}, {:id=>226, :rank=>99999999}, {:id=>241, :rank=>3}, {:id=>244, :rank=>99999999}, {:id=>261, :rank=>99999999}, {:id=>278, :rank=>99999999}, {:id=>295, :rank=>99999999}, {:id=>312, :rank=>99999999}, {:id=>329, :rank=>99999999}, {:id=>346, :rank=>99999999}, {:id=>361, :rank=>99999999}, {:id=>364, :rank=>99999999}, {:id=>381, :rank=>99999999}, {:id=>398, :rank=>99999999}, {:id=>415, :rank=>99999999}, {:id=>432, :rank=>99999999}, {:id=>449, :rank=>99999999}, {:id=>466, :rank=>99999999}, {:id=>481, :rank=>99999999}, {:id=>484, :rank=>99999999}, {:id=>501, :rank=>99999999}, {:id=>518, :rank=>99999999}, {:id=>535, :rank=>99999999}, {:id=>552, :rank=>99999999}, {:id=>569, :rank=>99999999}, {:id=>586, :rank=>99999999}, {:id=>601, :rank=>99999999}, {:id=>604, :rank=>99999999}, {:id=>621, :rank=>99999999}, {:id=>638, :rank=>99999999}, {:id=>655, :rank=>99999999}, {:id=>672, :rank=>99999999}, {:id=>689, :rank=>99999999}, {:id=>706, :rank=>99999999}, {:id=>721, :rank=>99999999}, {:id=>724, :rank=>99999999}, {:id=>741, :rank=>10}, {:id=>758, :rank=>99999999}, {:id=>775, :rank=>99999999}, {:id=>792, :rank=>99999999}, {:id=>809, :rank=>99999999}, {:id=>826, :rank=>99999999}, {:id=>841, :rank=>6}, {:id=>844, :rank=>99999999}, {:id=>861, :rank=>99999999}, {:id=>878, :rank=>99999999}, {:id=>895, :rank=>99999999}, {:id=>912, :rank=>2}, {:id=>929, :rank=>9}, {:id=>946, :rank=>99999999}, {:id=>961, :rank=>99999999}, {:id=>964, :rank=>1}, {:id=>981, :rank=>19}, {:id=>998, :rank=>99999999}, {:id=>1015, :rank=>99999999}, {:id=>1032, :rank=>99999999}, {:id=>1049, :rank=>99999999}, {:id=>1066, :rank=>99999999}, {:id=>1081, :rank=>3}, {:id=>1084, :rank=>4}, {:id=>1101, :rank=>6}, {:id=>1118, :rank=>25}, {:id=>1135, :rank=>2}, {:id=>1152, :rank=>6}, {:id=>1169, :rank=>24}, {:id=>1186, :rank=>99999999}, {:id=>1201, :rank=>99999999}, {:id=>1204, :rank=>99999999}, {:id=>1221, :rank=>99999999}, {:id=>1238, :rank=>99999999}, {:id=>1255, :rank=>99999999}, {:id=>1272, :rank=>99999999}, {:id=>1289, :rank=>99999999}, {:id=>1306, :rank=>99999999}, {:id=>1321, :rank=>99999999}, {:id=>1324, :rank=>99999999}, {:id=>1341, :rank=>99999999}, {:id=>1358, :rank=>99999999}, {:id=>1375, :rank=>99999999}, {:id=>1392, :rank=>99999999}, {:id=>1409, :rank=>99999999}, {:id=>1426, :rank=>99999999}, {:id=>1441, :rank=>99999999}, {:id=>1444, :rank=>99999999}, {:id=>1461, :rank=>99999999}, {:id=>1478, :rank=>99999999}, {:id=>1495, :rank=>99999999}, {:id=>1512, :rank=>99999999}, {:id=>1529, :rank=>99999999}, {:id=>1546, :rank=>99999999}, {:id=>1561, :rank=>99999999}, {:id=>1564, :rank=>99999999}, {:id=>1581, :rank=>99999999}, {:id=>1598, :rank=>99999999}, {:id=>1615, :rank=>99999999}, {:id=>1632, :rank=>99999999}, {:id=>1649, :rank=>99999999}, {:id=>1666, :rank=>2}, {:id=>1681, :rank=>13}, {:id=>1684, :rank=>12}, {:id=>1701, :rank=>25}, {:id=>1718, :rank=>99999999}, {:id=>1735, :rank=>7}, {:id=>1752, :rank=>99999999}, {:id=>1769, :rank=>4}, {:id=>1786, :rank=>99999999}, {:id=>1801, :rank=>1}, {:id=>1804, :rank=>2}, {:id=>1821, :rank=>1}, {:id=>1838, :rank=>2}, {:id=>1855, :rank=>99999999}, {:id=>1872, :rank=>99999999}, {:id=>1889, :rank=>1}, {:id=>1906, :rank=>5}, {:id=>1921, :rank=>5}, {:id=>1924, :rank=>7}, {:id=>1941, :rank=>1}, {:id=>1958, :rank=>7}, {:id=>1975, :rank=>5}, {:id=>1992, :rank=>7}, {:id=>2009, :rank=>99999999}, {:id=>2026, :rank=>99999999}, {:id=>2041, :rank=>99999999}, {:id=>2044, :rank=>99999999}, {:id=>2061, :rank=>7}, {:id=>2078, :rank=>99999999}, {:id=>2095, :rank=>99999999}, {:id=>2113, :rank=>99999999}, {:id=>2130, :rank=>99999999}, {:id=>2148, :rank=>99999999}, {:id=>2161, :rank=>99999999}, {:id=>2164, :rank=>99999999}, {:id=>2181, :rank=>99999999}, {:id=>2198, :rank=>5}, {:id=>2215, :rank=>99999999}, {:id=>2232, :rank=>99999999}, {:id=>2249, :rank=>99999999}, {:id=>2266, :rank=>99999999}, {:id=>2281, :rank=>99999999}, {:id=>2284, :rank=>4}, {:id=>2301, :rank=>25}, {:id=>2318, :rank=>99999999}, {:id=>2335, :rank=>99999999}, {:id=>2352, :rank=>99999999}, {:id=>2369, :rank=>99999999}, {:id=>2386, :rank=>99999999}, {:id=>2401, :rank=>99999999}, {:id=>2404, :rank=>99999999}, {:id=>2421, :rank=>99999999}, {:id=>2438, :rank=>99999999}, {:id=>2455, :rank=>99999999}, {:id=>2472, :rank=>99999999}, {:id=>2489, :rank=>99999999}, {:id=>2506, :rank=>99999999}, {:id=>2521, :rank=>99999999}, {:id=>2524, :rank=>99999999}, {:id=>2541, :rank=>99999999}, {:id=>2558, :rank=>99999999}, {:id=>2575, :rank=>99999999}]

    ranks.each do |r|
      role = Role.find(r[:id])
      role.rank = r[:rank]
      role.save
    end
    #DB = Sequel.connect('postgres://cooper:home3232@localhost:5432/test')
    #roles = DB['select d.rank as rank, a.id as project_id, a.title as project_title, e.id as position_id, e.title as position_title, c.id as person_id, c.title as person_title
      #from article as a
      #join articles_related as b
      #on a.id = b.article_id
      #join article as c
      #on b.article_related_id = c.id
      #join articles_people_positions as d
      #on b.id = d.related_id
      #join people_positions as e
      #on d.position_id = e.id']

    #roles.each do |role|
      #found =  Role.all.select{|r| r.project.old_id == role[:project_id] &&  r.person.old_id == role[:person_id] && r.position.old_id == role[:position_id] }.first

      #if found  
        #found.rank = role[:rank]
        #puts found.save
      #end
    #end
  end

end
