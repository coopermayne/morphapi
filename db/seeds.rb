DB = Sequel.connect('postgres://cooper:home3232@localhost:5432/test')

def get_sections
  sections = DB['select id, title from section']
  sections.each do |section|
    Section.create(section)
  end

  #add morph section and add seed ranks
  Section.create(id: 13, title: "Morphosis", rank: 1)
  Section.create(id: 14, title: "News", rank: 6)

  Section.all.each do |sec|
    if sec.id == 1
      sec.rank = 1
    elsif sec.id == 2
      sec.rank = 3
      sec.title = "Urban"
    elsif sec.id == 4
      sec.rank = 4
      sec.title = "Tangents"
    elsif sec.id == 6
      sec.rank = 5
    end

    sec.save
  end
end


def get_types
  types = DB['select id, title, rank from project_type']
  types.each do |type|
    ProjectType.create(type)
  end

  ProjectType.create({id: 19, title: 'Product', rank: 100})
end


def get_people
  people = DB['select a.id as id, a.title as name, a.overview, a.description, a.hit, b.last_name, b.birthday, b.employed as is_employed, b.is_morphosis, b.is_collaborator, b.is_consultant
            from article as a
            left join people_details as b
            on a.id = b.article_id
            where a.type_id = 4']

  #get person data
  people.each do |person|
    overview = person[:overview]

    if overview && overview.match(/Locate/i)
      person[:location] = overview
    elsif overview && overview.match(/href="(.*?)"/)
      website = overview.match(/href="(.*?)"/)[1]
      person[:website] = website
    end

    person.delete(:overview)

    Person.create(person)
  end

  #fill in education and email data
  additional_data = DB['select b.id as person_id, a.*
                      from additional_detail as a
                      left join article as b
                      on a.article_id = b.id
                      where b.type_id = 4']

  additional_data.each do |data_item|

    person = Person.find(data_item[:article_id])

    if data_item[:additional_detail_id]==1 #education
      person.educations << Education.new({title: data_item[:description]})
    elsif data_item[:additional_detail_id]==3 #email
      person.email = data_item[:description]
    end

    person.save
  end

  #TODO add section to people...?
end

def get_projects
  projects = DB['select *
     from article as a
     left join project_details as d
     on a.id = d.article_id
     where a.type_id=3']
  
  projects.each do |project|
    [:budget, :collaborator_rank, :consultant_rank, :is_meta, :is_see_in, :morphosis_team_rank, :news_phrase, :people_display_count, :photo, :slug, :sub_type, :type_id, :updated_at].each { |item| project.delete(item) }

    project[:city] = project[:city_id] && DB["select name from cp_cities where id=#{project[:city_id]}"].first[:name]
    project.delete(:city_id)

    project[:state] = project[:state_id] && DB["select name from cp_states where id=#{project[:state_id]}"].first[:name]
    project.delete(:state_id)

    project[:country] = project[:country_id] && DB["select name from cp_countries where id=#{project[:country_id]}"].first[:name]
    project.delete(:country_id)

    project[:id] = project[:article_id]
    project.delete(:article_id)

    #add section... section
    if project[:section_id].is_a? Integer
      section = Section.find(project[:section_id])
      project.delete(:section_id)
      pp = Project.new(project)
      pp.section = section
      pp.save
    else
      pp = Project.new(project)
      pp.save
    end
  end

  #connect to project types
  many_to_many = DB['select article_id, project_type_id from article_project_type']
  many_to_many.each do |item|
    p = Project.find(item[:article_id])
    t = ProjectType.find(item[:project_type_id])
    p.project_types << t
    p.save
  end
end

def make_products_sub_cat_of_t_and_o

  outtakes_section = Section.find(4)
  product_type = ProjectType.find(19)

  Project.where(section_id:3).each do |p|
    p.section = outtakes_section
    p.project_types << product_type
    p.save
  end

end

def get_roles
  positions = DB['select id, title, rank from people_positions']
  positions.each do |position|
    Position.create(position)
  end

  roles = DB['select a.id as project_id, a.title as project_title, e.id position_id, e.title as position_title, c.id as person_id, c.title as person_title
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
    pr = Project.find(role[:project_id])
    pos = Position.find(role[:position_id])
    per = Person.find(role[:person_id])

    r = Role.create
    r.project = pr
    r.position = pos
    r.person = per
    r.save

  end
end

def get_components
  component_types = DB['select * from article_info_category']
  component_types.each do |component_type|
    ComponentType.create(component_type)
  end

  components = DB['select * from article_info']
  components.each do |component|
    pr = Project.find(component[:article_id])
    ct = ComponentType.find(component[:cat_id])
    [:article_id, :cat_id].each {|item| component.delete(item)}
    c = Component.create(component)
    c.project = pr
    c.component_type = ct
    c.save

  end
end

def get_bibliography
  items = DB['select a.id, a.title, a.description, a.overview, a.hit, b.author, b.article_name, b.book_title, b.subtitle, b.publication, b.publisher, b.date, b.pub_date, b.pages
               from article as a
               join bibliography_details as b
               on a.id = b.article_id
               where a.sub_type = 1']
  items.each do |item|
    BibliographyItem.create(item)
  end

  #connect projects to bibliography items
  connections = DB['select a.id as project_id, c.id as bib_id
                   from article as a
                   join articles_related as b
                   on a.id = b.article_id
                   join article as c
                   on b.article_related_id = c.id
                   where c.sub_type=1 and a.type_id = 3']
  connections.each do |connection|
    pr = Project.find(connection[:project_id])
    bi = BibliographyItem.find(connection[:bib_id])
    bi.projects << pr
    bi.save
  end

end

def get_awards
  awards = DB['select a.id, a.title, a.description, a.overview, a.hit, b.year
               from article as a
               join award_details as b
               on a.id = b.article_id
               where a.sub_type = 2']
  awards.each do |award|
    Award.create(award)
  end

  #connect projects to awards items
  connections = DB['select a.id as project_id, c.id as award_id
                   from article as a
                   join articles_related as b
                   on a.id = b.article_id
                   join article as c
                   on b.article_related_id = c.id
                   where c.sub_type=2 and a.type_id = 3']
  connections.each do |connection|
    pr = Project.find(connection[:project_id])
    award = Award.find(connection[:award_id])
    award.projects << pr
    award.save
  end
end

def get_news_types
  types = DB['select id, title, rank from news_types']
  types.each do |t|
    NewsType.create(t)
  end
end

def get_news_items
  newsitems = DB['select a.id, a.title, a.overview, a.description, a.created_at, a.updated_at, a.hit, b.start_date, b.end_date, b.place_name, b.street_address, b.country_id, b.state_id, b.city_id, b.zip, b.news_type_id
     from article as a
     left join news_details as b
     on a.id = b.article_id
     where type_id = 2']
  newsitems.each do |newsitem|
    newsitem[:city] = newsitem[:city_id] && DB["select name from cp_cities where id=#{newsitem[:city_id]}"].first[:name]
    newsitem.delete(:city_id)

    newsitem[:state] = newsitem[:state_id] && DB["select name from cp_states where id=#{newsitem[:state_id]}"].first[:name]
    newsitem.delete(:state_id)

    newsitem[:country] = newsitem[:country_id] && DB["select name from cp_countries where id=#{newsitem[:country_id]}"].first[:name]
    newsitem.delete(:country_id)

    if(newsitem[:news_type_id].to_i > 0)
      news_type = NewsType.find(newsitem[:news_type_id])
    else
      news_type = nil
    end
    newsitem.delete(:news_type_id)

    n = NewsItem.new(newsitem)
    n.news_type = news_type
    n.save

  end
end

def get_file_types
  file_types = DB['select * from file_type']
  file_types.each do |file_type|
    n = FileType.new(file_type)
    n.save
  end
end

def get_credits
  credits = DB['select * from file_credits']
  credits.each do |credit|
    n = Credit.new(credit)
    n.save
  end
end

def get_files
  errors = 0

  files = DB['select 
  a.rank, 
  b.id as project_id,
  b.photo as primary_photo_id,
  b.type_id,
  b.sub_type, 
  c.id as image_article_id,
  c.title as image_title,
  d.file_name,
  d.file_type as file_type_id,
  d.credit as credit_id,
  d.file_ext

  from article_file as a
  left join article as b
  on a.article_id = b.id
  left join article as c
  on a.file_article_id = c.id
  left join file_details as d
  on d.article_id = a.file_article_id
  left join file_credits as e
  on e.id = d.credit
  where b.id = 288
  or b.id = 110
             ']

  files.each do |file|
    #only images for now
    begin

      is_primary = file[:image_article_id]==file[:primary_photo_id]

      if file[:file_ext]=='jpg'
        up = Upload.new()

        if file[:type_id]==3
          obj = Project.find(file[:project_id])
        elsif file[:type_id]==4
          obj = Person.find(file[:project_id])
        elsif file[:type_id]==2
          obj = NewsItem.find(file[:project_id])
        end

        if is_primary
          obj.primary_image = up
          obj.save
        end

        up.uploadable = obj

        up.title = file[:image_title]
        up.rank = file[:rank]
        up.copyright = false
        t_id = file[:file_type_id]
        c_id = file[:credit_id]
        up.file_type = FileType.exists?(t_id) ? FileType.find(t_id) : nil
        up.credit = Credit.exists?(c_id) ? Credit.find(c_id) : nil

        #add image to amazon bucket
        n = file[:file_name] + "-l." + file[:file_ext]

        #up.remote_name_url = "http://morphopedia.com/uploads/" + n

        if up.save
          puts 'saved: ' + up.title
          #puts 'url: ' + up.name.url
          puts 
        else
          puts "file name: " + n
          ft = up.file_type ? up.file_type.title : 'nil'
          puts "file type: " + ft
          puts "belongs to: "  +  up.uploadable.class.to_s
          puts
        end
      end

    rescue => error
      errors += 1
      puts "","RESCUE",""
      puts error
    end
    puts "errors: " + errors.to_s
  end
end

get_sections
get_types
get_people
get_projects
make_products_sub_cat_of_t_and_o
get_roles
get_components
get_bibliography
get_awards
get_news_types
get_news_items
get_file_types
get_credits
get_files
