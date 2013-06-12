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
