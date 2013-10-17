// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below. Any JavaScript/Coffee file within this directory, lib/assets/javascripts, 
// vendor/assets/javascripts, or vendor/assets/javascripts of plugins, if any, can be referenced 
// here using a relative path.
//
//  jQuery Javascript
//= require jquery
//= require jquery_ujs
//
//  Blacklight Javascript
//    If we require all of Blacklight, we also get whatever version of bootstrap it's using.
//    However, we want to use our own version of bootstrap, and not the one that comes with
//    Blacklight.  Here we include all of Blacklight's js files individually, and not the
//    the Blacklight's bootstrap files.  Those will be included next.
//= require blacklight/core
//= require blacklight/bookmark_toggle
//= require blacklight/facet_expand_contract
//= require blacklight/lightbox_dialog
//= require blacklight/search_context
//= require blacklight/select_submit
//= require blacklight/zebra_stripe
//= require blacklight/css_dropdowns
//
//  Use our own installed version of Boostrap, and not the one that comes with Blacklight.
//= require bootstrap
//
//  Vendor assets
//= require flowplayer-5.3.2.min.js
//= require video.js
//= require bootstrap-combobox.js
//
//  Include our custom js files
//= require_tree .

// Hacky way of dealing with asset pipeline and running your app with passenger
// and a suburi.  Use this variable in conjunction with:
// RAILS_RELATIVE_URL_ROOT=/hydra rake assets:precompile
var ROOT_PATH = "/";