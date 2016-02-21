# lib/tasks/custom_seed.rake
namespace :db do
  desc "and in_gallery values to images"
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

  task get_pdfs: :environment do
    #TODO
  end

  task get_docs: :environment do
    #TODO
  end

  task get_flvs: :environment do
    #TODO
  end

  task connect_bib_and_people: :environment do
    #TODO
  end

  task include_timestamps: :environment do
    #TODO
  end

  task include_timestamps: :environment do
    #TODO
  end

  task connect_news_items_and_projects: :environment do
    #TODO
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

  task generate_search_results: :environment do
    SearchResult.destroy_all

    [Award, BibliographyItem, NewsItem, Person, Project].each do |model|
      model.all.each do |instance|
        instance.autocreate_searchable
        instance.update_search_content
      end
    end
  end
end
