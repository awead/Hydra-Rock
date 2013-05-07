// Rockhall flash_message.js
//
// Some simple functions that render flash messages in <div class="flash_messages">

function flashInfo(message) {
  var html = '<div class="alert alert-info">'+message+'<button type="button" class="close" data-dismiss="alert">&times;</button></div>'
  $('div.flash_messages').append(html)
}

function flashAlert(message) {
  var html = '<div class="alert">'+message+'<button type="button" class="close" data-dismiss="alert">&times;</button></div>'
  $('div.flash_messages').append(html)
}

function flashWarning(message) {
  var html = '<div class="alert alert-warning">'+message+'<button type="button" class="close" data-dismiss="alert">&times;</button></div>'
  $('div.flash_messages').append(html)
}