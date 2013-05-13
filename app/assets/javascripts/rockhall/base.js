/*
Rockhall base.js

Includes the basic javascript functions for the Hydra-Rock application 
*/

var formChanged = false;

// sanity check
function hiMom() {
  alert('Hi, mom!');
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

function submitOnChanged(event) {
  if (!formChanged) {
    flashAlert('No changes made')
    event.preventDefault();
  }
}

// makes an ajax call to reload the video list given by the external_videos/show/list partial
function reloadVideos() {

  // Look through our url and find the pid
  var pid = jQuery.grep(window.location.pathname.split('/'), function (element) {
    if(element.indexOf(':') !== -1) {
      return element;
    }
  });

  var url = ROOT_PATH+'archival_videos/'+pid+'/external_videos';

  $.ajax({
    type: 'GET',
    url: url,
    cache: false,
    success: function(data) {
      $('#video_list').html(data);
      //formChanged = false;
    },
    error: function(xhr, ajaxOptions, thrownError) {
      alert(xhr.status);
      alert(thrownError);
    }
  });

}

// Typeahead function that's used when fillout certain text fields.  Uses getTerms()
// to get options from a locally-stored, static json file.
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

// Show/hide tech info in the show view
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

// Adding and removing simple fields in edit views.  There are fields that can be added and removed
// within the form, and do not required addtions or deletions of xml nodes.
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
  formChanged = true;
  event.preventDefault();
});

// Flip the formChanged switch whenever a form element changes
$(document).on('change', 'input,select', function(event) {
  formChanged = true;
});

$(document).on('click', '.refresh_videos, .modal-backdrop', function(event) {
  reloadVideos();
  event.preventDefault();
});

