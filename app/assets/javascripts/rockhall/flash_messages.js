// Rockhall flash_message.js
//
// Some simple functions that render flash messages in <div class="flash_messages">

function flashInfo(message) {
  var html = '<li class="dropdown open"><ul id="flash_message" class="dropdown-menu"><div class="alert alert-info"><li>'+message+'</li></div></ul></li>'
  $('#flash_message').parent().remove();
  $('ul.flash').append(html)
}

function flashAlert(message) {
  var html = '<li class="dropdown open"><ul id="flash_message" class="dropdown-menu"><div class="alert"><li>'+message+'</li></div></ul></li>'
  $('#flash_message').parent().remove();
  $('ul.flash').append(html)
}

function flashWarning(message) {
  var html = '<li class="dropdown open"><ul id="flash_message" class="dropdown-menu"><div class="alert alert-warning"><li>'+message+'</li></div></ul></li>'
  $('#flash_message').parent().remove();
  $('ul.flash').append(html)
}

// Remove the message if you click on it
$(document).on('click', '#flash_message', function(event) {
  $(this).parent().remove();
});

// or, it goes away by itself after 3 seconds
setTimeout(function() {
  $('#flash_message').remove();
}, 3000);
