
  
jQuery(document).ready(function() {
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
});
