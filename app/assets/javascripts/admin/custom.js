$(document).ready(function(){

	$.fn.bootstrapSwitch.defaults.size = 'small';
	$.fn.bootstrapSwitch.defaults.labelWidth = 'auto';

	$(".fancy-checkbox").bootstrapSwitch();

	$('.assoc').on('change', function(){
		var optionSelected = $(this).find("option:selected");
		var textSelected   = optionSelected.text();
		$("#slide_title").val(textSelected)
	})

  if ( $(".index-table").length ){
    $('.index-table').DataTable({
      "lengthMenu": [ 15, 25, 50 ],
			"order": [],
      "columnDefs": [
        { "orderable": false, "targets": [-1, -2] }
      ]
    });
  }

	//only allow one make-primary and one make-index selection
	$('input.make-primary').on('switchChange.bootstrapSwitch', function(event, state) {
		if(state){
			$('.make-primary').not($(this)).bootstrapSwitch('state', false)
		}
	});
	$('input.make-index').on('switchChange.bootstrapSwitch', function(event, state) {
		if(state){
			$('.make-index').not($(this)).bootstrapSwitch('state', false)
		}
	});

  $('input[type=submit]').on('click', function(e){
    var el = $(e.target)
    el.addClass('btn-info')
    el.attr('value', 'processing...')

    setTimeout(function(){
      el.attr('value', 'still going!')
    }, 2000);

    setTimeout(function(){
      el.attr('value', 'stay with me...')
    }, 4000);

    setTimeout(function(){
      el.attr('value', 'we are getting there')
    }, 6000);

  });

  //trumbowyg
  applyTextBox($('textarea'))

	//chosen
	applyChosen();

  //image popover on hover
  $('a[rel=popover]').popover({
    html: true,
    trigger: 'hover',
    template: '<div class="popover"> <div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>',
    content: function(){return '<img src="'+$(this).data('img') + '" />';}
  });

  $('form').on('click', '.add_fields', function(event) {
    //add the form partial
    var regexp, time;
    time = new Date().getTime();
    regexp = new RegExp($(this).data('id'), 'g');
    $(this).before($(this).data('fields').replace(regexp, time));
    //add trumbowyg

		//apply javascript stuff
		applyJsStuff()
    event.preventDefault();
  });

  $('form').on('click', '.remove_fields', function(event){
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault();
  })


  //manage type/subtype selection
  $('.subtype input').on('change', function(a,b,c){
    var t_el = $(a.target)
    var isChecked=t_el.is(':checked')
    if(isChecked){
      //check all parent checkboxes...
      t_el.parents('.type').children('input:checkbox').prop("checked", true)
    }
  })

  $('.type input').on('change', function(a,b,c){
    var t_el = $(a.target)
    var isChecked=t_el.is(':checked')
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


	var el_lat = $('input[name="project[lat]"]')
	var el_lon = $(' input[name="project[lon]"]')

	$("#geocomplete").geocomplete(
		{
			markerOptions: {
				draggable: true
			},
			map: ".map_canvas",
			types: ['geocode','establishment'],
			location: new google.maps.LatLng(el_lat.val(),el_lon.val())
		}
	)
		.bind("geocode:result", function(event, result){
			var formatted = result.formatted_address
			var lat = result.geometry.location.lat()
			var lng = result.geometry.location.lng()

			el_lat.val(lat)
			el_lon.val(lng)


			var address_components = result.address_components;
			var components={}; 
			jQuery.each(address_components, function(k,v1) {jQuery.each(v1.types, function(k2, v2){components[v2]=v1.long_name});})

			$(' input[name="project[street_address]"]').val([ components.street_number, components.route ].join(" "))
			$(' input[name="project[city]"]').val(components.locality)
			$(' input[name="project[state]"]').val(components.administrative_area_level_1)
			$(' input[name="project[country]"]').val(components.country)
			$(' input[name="project[zip]"]').val(components.postal_code)

		})
		.bind("geocode:dragged", function(event, latLng){
			el_lat.val(latLng.lat())
			el_lon.val(latLng.lng())
		})
})

var applyChosen = function(){
	$('.chosen-select').chosen({
		allow_single_deselect: true,
		no_result_text: 'No results matched',
		width: '200px'
	});
}


var applyTextBox = function(jquery_el){
  jquery_el.trumbowyg({
    autogrow: false,
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
}

var applyJsStuff = function(){
	applyTextBox($('textarea'))
	applyChosen();
	$(".filestyle").filestyle();
}
