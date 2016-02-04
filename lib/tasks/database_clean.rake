# lib/tasks/custom_seed.rake
namespace :db do
  desc "Correction of sequences id"
  task format_galleries: :environment do
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
end
