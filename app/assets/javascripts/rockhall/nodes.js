/*
Rockhall nodes.js

Javscript functions used when dealing with nodes, or additiona bits of xml that are added and removed from docments.
*/

// Reloads a give node edit partial
function reloadNodeForm(type) {
  var jqxhr = $.ajax({
    url: ROOT_PATH+'nodes/'+$('#main-container').data('pid')+'/'+type+'/edit',
    dataType: 'script'
  });

  jqxhr.always( function (data) {
    $('#'+type+'s_form').html(data.responseText);
    formChanged = false;
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
$(document).on('click', '.refresh_contributors', function(event) {
  reloadNodeForm('contributor');
  event.preventDefault();
});

$(document).on('click', '.delete_contributors', function(event) {
  deleteNode('contributor', $(this).attr('href'));
  event.preventDefault();
}); 

// ################################################################################
// publishers
$(document).on('click', '.refresh_publishers', function(event) {
  reloadNodeForm('publisher');
  event.preventDefault();
});

$(document).on('click', '.delete_publishers', function(event) {
  deleteNode('publisher', $(this).attr('href'));
  event.preventDefault();
}); 

// ################################################################################
// accessions
$(document).on('click', '.refresh_accessions', function(event) {
  reloadNodeForm('accession');
  event.preventDefault();
});

$(document).on('click', '.delete_accessions', function(event) {
  deleteNode('accession', $(this).attr('href'));
  event.preventDefault();
}); 

// ################################################################################
// events
$(document).on('click', '.refresh_events', function(event) {
  reloadNodeForm('event');
  event.preventDefault();
});

$(document).on('click', '.delete_events', function(event) {
  deleteNode('event', $(this).attr('href'));
  event.preventDefault();
}); 

// ################################################################################
// collections
$(document).on('click', '.refresh_collections', function(event) {
  reloadNodeForm('collection');
  event.preventDefault();
});

$(document).on('click', '.delete_collections', function(event) {
  deleteNode('collection', $(this).attr('href'));
  event.preventDefault();
});

// Reload content if the user closes the model without clicking on the (x)
$(document).on('click', '.modal-backdrop', function(event) {

   if ($('#ajax-modal form').attr('id') === 'add_contributor')
      reloadNodeForm('contributor');
   if ($('#ajax-modal form').attr('id') === 'add_publisher')
      reloadNodeForm('publisher');
   if ($('#ajax-modal form').attr('id') === 'add_event')
      reloadNodeForm('event');
   if ($('#ajax-modal form').attr('id') === 'add_accession')
      reloadNodeForm('accession');
   if ($('#ajax-modal form').attr('id') === 'add_collection')
      reloadNodeForm('collection');    

});
