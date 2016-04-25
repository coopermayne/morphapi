#json.(@project, :id, :title, :overview, :description, :program, :client, :size, :site_area, :lat)

json.result do |json|

  json.galleries @project.getGalleries do |title, images|
    json.title title
    json.images images do |image|
      json.extract! image, :id, :name, :title
      json.credit image.credit ? image.credit.name : nil
    end
  end

  json.merge! @project.attributes
  json.types @project.project_types.map{|t| t.title }
  json.primary_image @project.primary_image

  json.documents @project.getDocuments

  morphosites = @project.roles.select{|r| r.person.is_morphosis}
  contractors = @project.roles.select{|r| !r.person.is_morphosis}

  gr_morph = morphosites.group_by{|n| n.position}.sort_by{|k,v| k.rank}

  json.morph_team gr_morph do |gr|
    json.role_title gr.first.title
    json.people gr.last.sort_by{|r| [r.rank, r.person.last_name]} do |role|
      json.person role.person, :id, :name, :last_name
    end
  end

  gr_con = contractors.group_by{|n| n.position}.sort_by{|k,v| [ v.map(&:rank).min, k.rank ]}
  json.contractors gr_con do |gr|
    json.role_title gr.first.title
    json.people gr.last.sort_by(&:rank) do |role|
      json.person role.person, :id, :name, :last_name
    end
  end

  json.awards @project.awards.sort_by{|a| a.year || 0 }.reverse, :id, :title, :year
  json.bibliography_items @project.bibliography_items do |bib|
    json.merge! bib.attributes
    json.primary_image bib.primary_image
  end

  json.components @project.components.select(&:is_visible) do |comp|
    json.merge! comp.attributes
  end
end
