// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//  jQuery Javascript
//= require jquery
//= require jquery_ujs
//
//  Blacklight Javascript
//    If we require all of Blacklight, we also get whatever version of bootstrap it's using
//    but we want to use our own version of bootstrap, and not the one that comes with
//    Blacklight.  So we'll include all of Blacklight's js files individually.
//= require blacklight/core
//= require blacklight/bookmark_toggle
//= require blacklight/facet_expand_contract
//= require blacklight/lightbox_dialog
//= require blacklight/search_context
//= require blacklight/select_submit
//= require blacklight/zebra_stripe
//= require blacklight/css_dropdowns
//
//  Our installed version of Boostrap
//= require bootstrap
//
//  And anything else ...
//= require_tree .

// Hacky way of dealing with asset pipeline and running your app with passenger
// and a suburi.  Use this variable in conjunction with:
// RAILS_RELATIVE_URL_ROOT=/hydra rake assets:precompile
var ROOT_PATH = "/";