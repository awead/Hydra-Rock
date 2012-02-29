// Rockhall javascript

// to do something onload:
// $(document).ready(myFunction);
// and define myFunction below.

function updateContributor(index) {
  var role = $('#contributor_select_' + index + ' option:selected').text()
  var ref  = $('#contributor_select_' + index).val();
  $('input#contributor_' + index + '_role').val(role);
  $('input#contributor_' + index + '_role_ref').val(ref);
}

function updatePublisher(index) {
  var role = $('#publisher_select_' + index + ' option:selected').text()
  var ref  = $('#publisher_select_' + index).val();
  $('input#publisher_' + index + '_role').val(role);
  $('input#publisher_' + index + '_role_ref').val(ref);
}
