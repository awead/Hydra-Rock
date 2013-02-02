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
$(document).ready(refreshContributors);
$(document).ready(deleteContributors);
$(document).ready(refreshPublishers);
$(document).ready(deletePublishers);

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

function refreshContributors() {

  $('.refresh_contributors, .modal-backdrop').live("click", function(action) {
    reloadContributorsForm();
    action.preventDefault();
  });    

}

function refreshPublishers() {

  $('.refresh_publishers, .modal-backdrop').live("click", function(action) {
    reloadPublishersForm();
    action.preventDefault();
  });    

}

function deleteContributors() {

  $('.delete_contributors').live("click", function(action) {
    url = $(this).attr("href")
    $.ajax({
      type: "GET",
      url: url,
      cache: false,
      success: reloadContributorsForm,
      error: function(xhr, ajaxOptions, thrownError) {
        alert(xhr.status);
        alert(thrownError);
      }
    });
    action.preventDefault();
  }); 
}

function deletePublishers() {

  $('.delete_publishers').live("click", function(action) {
    url = $(this).attr("href")
    $.ajax({
      type: "GET",
      url: url,
      cache: false,
      success: reloadPublishersForm,
      error: function(xhr, ajaxOptions, thrownError) {
        alert(xhr.status);
        alert(thrownError);
      }
    });
    action.preventDefault();
  }); 
}

function reloadContributorsForm() {

  // Look through our url and find the pid
  var pid = jQuery.grep(window.location.pathname.split("/"), function (element) {
    if(element.indexOf(":") !== -1) {
      return element;
    }
  });

  var url = ROOT_PATH+"nodes/"+pid+"/contributor/edit";

  $.ajax({
    type: "GET",
    url: url,
    cache: false,
    success: function(data) {
      $('#contributors_form').html(data);
    },
    error: function(xhr, ajaxOptions, thrownError) {
      alert(xhr.status);
      alert(thrownError);
    }
  });

}

function reloadPublishersForm() {

  // Look through our url and find the pid
  var pid = jQuery.grep(window.location.pathname.split("/"), function (element) {
    if(element.indexOf(":") !== -1) {
      return element;
    }
  });

  var url = ROOT_PATH+"nodes/"+pid+"/publisher/edit";

  $.ajax({
    type: "GET",
    url: url,
    cache: false,
    success: function(data) {
      $('#publishers_form').html(data);
    },
    error: function(xhr, ajaxOptions, thrownError) {
      alert(xhr.status);
      alert(thrownError);
    }
  });

}
