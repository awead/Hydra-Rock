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

// Wire-up our different node forms

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