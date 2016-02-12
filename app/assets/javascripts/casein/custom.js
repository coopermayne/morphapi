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

  $('.subtype input').on('change', function(a,b,c){
    var t_el = $(a.target)
    var isChecked=t_el.is(':checked')
    console.log(isChecked);
    if(isChecked){
      //check all parent checkboxes...
      t_el.parents('.type').children('input:checkbox').prop("checked", true)
    }
  })
  $('.type input').on('change', function(a,b,c){
    var t_el = $(a.target)
    var isChecked=t_el.is(':checked')
    console.log(isChecked);
    if(!isChecked){
      //uncheck kids
      t_el.siblings('.subtype').find('input:checkbox').prop("checked", false)
    }
  })

  $('.types').hide()
    $('.section'+$('.section select').val()).show()

  $('.section select').on('change', function(e){
    var el = $( e.target )
    $('.types').hide()
    $('.section'+el.val()).show()
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
      '|', 'btnGrp-lists',
      '|', 'horizontalRule'
    ]
  })
})

