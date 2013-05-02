// Rockhall javascript

// sanity check
function hiMom() {
  alert('hi, mom!');
};

// Defines a simple function that parses a json file stored under public/json
// of our rails app.
function getTerms(term) {
  var items = [];
  jQuery.getJSON(ROOT_PATH+'json/'+term+'.json', function(data) {

    $.each(data, function(key, val) {
      items.push(val);
    });

  });
  return items;
}

// Reloads a give node edit partial
function reloadNodeForm(type) {

  // Look through our url and find the pid
  var pid = jQuery.grep(window.location.pathname.split('/'), function (element) {
    if(element.indexOf(':') !== -1) {
      return element;
    }
  });

  var url = ROOT_PATH+'nodes/'+pid+'/'+type+'/edit';

  $.ajax({
    type: 'GET',
    url: url,
    cache: false,
    success: function(data) {
      $('#'+type+'s_form').html(data);
    },
    error: function(xhr, ajaxOptions, thrownError) {
      alert(xhr.status);
      alert(thrownError);
    }
  });

}

// Delete a given node
function deleteNode(type, url) {
  $.ajax({
    type: 'POST',
    dataType: 'html',
    data: {'_method':'delete'},
    url: url,
    success: function(data) {
      $('#'+type+'s_form').html(data);
    },
    cache: false,
    error: function(xhr, ajaxOptions, thrownError) {
      alert(xhr.status);
      alert(thrownError);
    }
  });
}



jQuery(document).ready(function() {

  $('.pbcGen_auto').typeahead({ source: getTerms('pbcoreGenerations') });
  $('.insPhy_auto').typeahead({ source: getTerms('instantiationPhysical') });

  // When user selects a new archival collection, the options for archival component
  // will be updated via the ArchivalCollections controller.
  $('.collection_select').change(function() {
    var url = ROOT_PATH
            + 'archival_collections/'
            + $('select.collection_select option:selected').val()
            + '/archival_components.json';

    // remove existing options
    $('.component_select').empty();

    jQuery.getJSON(url, function(data) {
      $.each(data, function(key, val) {
        $('.component_select').append($('<option></option>')
          .attr('value', key).text(val));
      });
    });

  });

});

$(document).on('click', 'a.show_tech_info', function(event) {
  var parent  = $(this).parent('li').attr('id');
  $(this).toggleClass('show_tech_info');
  $(this).toggleClass('hide_tech_info');
  $.get(this, function(data) {
    $('#'+parent).slideDown('normal', function() { $(this).append(data); } );
  });
  event.preventDefault();
});

$(document).on('click', 'a.hide_tech_info', function(event) {
  var parent  = $(this).parent('li').attr('id');
  $(this).toggleClass('show_tech_info');
  $(this).toggleClass('hide_tech_info');
  $('#'+parent+' table').slideUp('normal', function() { $(this).remove(); } );
  event.preventDefault();
});

$(document).on('click', '.adder', function(event) {
  var cloneElement  = $(this).parent('div').clone();
  var deleteButton  = '<button class="remover btn-danger btn-mini"><i class="icon-minus icon-white"></i></button>'

  // clean-up our clone
  cloneElement.find('button').replaceWith(deleteButton);
  cloneElement.find('input').val('');

  $('#'+$(this).attr('id')+'_elements').slideDown('normal', function() { $(this).append(cloneElement); } );
  event.preventDefault();
});

$(document).on('click', '.remover', function(event) {
  $(this).parent().remove();
  event.preventDefault();
});

$(document).on('click', '.refresh_contributors, .modal-backdrop', function(event) {
  reloadNodeForm('contributor');
  event.preventDefault();
});

$(document).on('click', '.refresh_publishers, .modal-backdrop', function(event) {
  reloadNodeForm('publisher');
  event.preventDefault();
});

$(document).on('click', '.delete_contributors', function(event) {
  deleteNode('contributor', $(this).attr('href'));
  event.preventDefault();
}); 


