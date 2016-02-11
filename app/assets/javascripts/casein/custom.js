// CASEIN CUSTOM
// Use this file for your project-specific Casein JavaScript
//

$(document).ready(function(){
  $('form').on('click', '.add_fields', function(event) {
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    return event.preventDefault();
  });

  $('.sectiontype input').on('change', function(a,b,c){
    var t_el = $(a.target)
    var isChecked=t_el.is(':checked')
    console.log(isChecked);
    if(isChecked){
      //check all parent checkboxes...
      //only allow one section to be selected...
      t_el.parents(".section").children("input:checkbox").prop("checked", true)
      t_el.parents(".section").siblings(".section").find("input:checkbox").prop("checked", false)

      if(t_el.parents(".type")){
        t_el.parents(".type").children("input:checkbox").prop("checked", true)
      }

    } else {
      //uncheck all child checkboxes
      t_el.parent().find("input").prop("checked", false)
    }
  })

  $('textarea').trumbowyg({
    autogrow: true,
    fullscreenable: false,
    semantic: true,
    btns:[
      'viewHTML',
      '|', 'formatting',
      '|', 'btnGrp-design',
      '|', 'link',
      '|', 'insertImage',
      '|', 'btnGrp-lists',
      '|', 'horizontalRule'

    ]
  })
})

