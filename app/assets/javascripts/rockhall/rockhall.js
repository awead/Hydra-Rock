// Rockhall javascript

// to do something onload:
// $(document).ready(myFunction);
// and define myFunction below.

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
};

$(document).ready(showTech);
$(document).ready(hideTech);

jQuery(document).ready(function() {


  $('.pbcGen_auto').typeahead({ source: getTerms('pbcoreGenerations') });
  $('.insPhy_auto').typeahead({ source: getTerms('instantiationPhysical') });


});

function showTech() {
  $('.show_tech_info').live("click", function(action) {

    var parent  = $(this).parent("li").attr("id");
    $(this).toggleClass("show_tech_info");
    $(this).toggleClass("hide_tech_info");
    $.get(this, function(data) {
      $("#"+parent).slideDown("normal", function() { $(this).append(data); } );
    });
    action.preventDefault();

  });  
}

function hideTech() {
  $('.hide_tech_info').live("click", function(action) {
    var parent  = $(this).parent("li").attr("id");
    $(this).toggleClass("show_tech_info");
    $(this).toggleClass("hide_tech_info");
    $("#"+parent+" table").slideUp("normal", function() { $(this).remove(); } );
    action.preventDefault();
  });
} 
