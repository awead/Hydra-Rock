/*
Rockhall nodes.js

Javscript functions used when dealing with nodes, or additiona bits of xml that are added and removed from docments.
*/

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
      formChanged = false;
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
      flashInfo('Video was updated successfully')
      formChanged = false;
    },
    cache: false,
    error: function(xhr, ajaxOptions, thrownError) {
      alert(xhr.status);
      alert(thrownError);
    }
  });
}

// Wire-up our different node forms

// ################################################################################
// contributors
$(document).on('click', '.refresh_contributors, .modal-backdrop', function(event) {
  reloadNodeForm('contributor');
  event.preventDefault();
});

$(document).on('click', '.delete_contributors', function(event) {
  deleteNode('contributor', $(this).attr('href'));
  event.preventDefault();
}); 

// ################################################################################
// publishers
$(document).on('click', '.refresh_publishers, .modal-backdrop', function(event) {
  reloadNodeForm('publisher');
  event.preventDefault();
});

$(document).on('click', '.delete_publishers', function(event) {
  deleteNode('publisher', $(this).attr('href'));
  event.preventDefault();
}); 

// ################################################################################
// accessions
$(document).on('click', '.refresh_accessions, .modal-backdrop', function(event) {
  reloadNodeForm('accession');
  event.preventDefault();
});

$(document).on('click', '.delete_accessions', function(event) {
  deleteNode('accession', $(this).attr('href'));
  event.preventDefault();
}); 

// ################################################################################
// events
$(document).on('click', '.refresh_events, .modal-backdrop', function(event) {
  reloadNodeForm('event');
  event.preventDefault();
});

$(document).on('click', '.delete_events', function(event) {
  deleteNode('event', $(this).attr('href'));
  event.preventDefault();
}); 

// ################################################################################
// collections
$(document).on('click', '.refresh_collections, .modal-backdrop', function(event) {
  reloadNodeForm('collection');
  event.preventDefault();
});

$(document).on('click', '.delete_collections', function(event) {
  deleteNode('collection', $(this).attr('href'));
  event.preventDefault();
});
