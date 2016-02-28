module ApplicationHelper

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("admin/shared/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(fa_icon("plus", text: name.html_safe), '#', class: "add_fields btn btn-primary", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def sortable(column, title=nil)
    title ||= column.titleize
    direction = column==sort_column && sort_direction == 'asc' ? "desc" : "asc"

    link_to title, {:sort => column, :direction => direction, :type => params[:type] }
  end

  def recent_years
    {start_year: Date.today.year - 90, end_year: Date.today.year}
  end

end
