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

  task generate_search_results: :environment do
    [Award, BibliographyItem, NewsItem, Person, Project].each do |model|
      model.all.each do |instance|
        instance.autocreate_searchable
        instance.update_search_content
        puts instance.search_result
      end
    end
  end
end
