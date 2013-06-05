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
  var jqxhr = $.ajax({
    url: ROOT_PATH+'archival_videos/'+$('#main-container').data('pid')+'/external_videos',
    dataType: 'script'
  });

  jqxhr.always( function (data) {
    $('#video_list').html(data.responseText);
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
  var link = $(this);
  var text = link.text();

  link.toggleClass('loading');

  var jqxhr = $.get(this)
      .done(function(html) {
        link.toggleClass('show_tech_info').toggleClass('hide_tech_info');
        $('#'+parent).slideDown('normal', function() { $(this).append(html); } );
      })
      .fail(function(jqXHR, textStatus, errorThrown) {
        flashAlert('ERROR! - '+textStatus+': '+errorThrown);
      })
      .always(function() { 
        link.toggleClass('loading');
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

  $('#subjects input').typeahead({ 
    source: function (query, process) {      
      $.ajax({ 
        url: '/subjects.json?q='+query,
        dataType: 'json'
      }).always(function(data) {
        return process(data);
      });
    }
  });

  event.preventDefault();
});

$(document).on('click', '.remover', function(event) {
  $(this).parent().remove();
  formChanged = true;
  event.preventDefault();
});

// Flip the formChanged switch whenever a form element changes
$(document).on('change', 'input,select,textarea', function(event) {
  formChanged = true;
});

// Importing videos
$(document).on('click', '.refresh_videos', function(event) {
  reloadVideos();
  event.preventDefault();
});

// Reload video list if the user closes the modal
$(document).on('click', '.modal-backdrop', function(event) {
   if ($('#ajax-modal form').attr('id') === 'import_videos')
      reloadVideos();
});
