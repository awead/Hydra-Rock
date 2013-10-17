// Headings
// Queries our headings controller for JSON results

function headingSuggestions(term, query, process) {
  $.ajax({ 
    url: ROOT_PATH+'headings/'+term+'.json?q='+query,
    dataType: 'json'
  }).success(function(data) {
    return process(data);
  });
}

function buildSeriesOptions() {
  ead_id = $('#collection input').attr('value')
  if (ead_id != '') {
    var jqxhr = $.getJSON( ROOT_PATH+'artk/resources/'+ead_id+'/components', function() {
      console.log( 'Querying AT for components in '+ead_id );
      })
    .done(function(data) {
      var options = ['<option></option>'];
      $.each(data, function() {
        html = '<option value="'+this.pid+'"">'+this.title+'</options>';
        options.push(html);
        $('#archival_series select').html(options);
        $('#archival_series select').data('combobox').refresh()
      });
      $('#flash_message').parent().remove();
    })
    .fail(function() {
      flashWarning('Unable to load series information for '+ead_id+'.');
    });
  }
}
