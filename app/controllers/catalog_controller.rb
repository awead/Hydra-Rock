class CatalogController < ApplicationController

  include Blacklight::Catalog
  include Hydra::AccessControlsEnforcement
  include Rockhall::Controller::ControllerBehavior
  include Rockhall::Exports

  # User still needs the #update action in the catalog, so we only enforce Hydra
  # access controls when the user tries to just view a document they don't have
  # access to.
  before_filter :enforce_access_controls, :only => :show
  before_filter :get_af_doc, :only => :show
  before_filter :get_public_acticity, :only => :index

  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic << :add_access_controls_to_solr_params
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic << :exclude_unwanted_models

  SolrDocument.use_extension ::Rockhall::Exports

  #--------------------------------------------------------------------------------------
  #
  # Blacklight configuriation
  #

  configure_blacklight do |config|
    config.default_solr_params = {
      :qt   => 'search',
      :rows => 10,
      # we're not excluding anything from search results, for now.
      #:fq   => ["-has_model_s:\"info:fedora/afmodel:ExternalVideo\""]
    }

    # solr field configuration for search results/index views
    config.index.show_link            = 'title_display'
    config.index.record_display_type  = 'format'

    # solr field configuration for document/show views
    config.show.html_title            = 'title_display'
    config.show.heading               = 'title_display'

    # This is the field that's used to determine the partial type
    config.show.display_type          = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    config.add_facet_field 'format',                    :label => 'Media Type',          :limit => 10
    config.add_facet_field 'media_format_facet',        :label => 'Physical Format',     :limit => 10
    config.add_facet_field 'contributor_name_facet',    :label => 'Name',                :limit => 10
    config.add_facet_field 'subject_facet',             :label => 'Subject',             :limit => 10
    config.add_facet_field 'genre_facet',               :label => 'Genre',               :limit => 10
    config.add_facet_field 'series_facet',              :label => 'Event/Series',        :limit => 10  
    config.add_facet_field 'create_date_facet',         :label => 'Creation Date',       :limit => 10
    config.add_facet_field 'language_facet',            :label => 'Language',            :limit => true
    config.add_facet_field 'priority_facet',            :label => 'Priority',            :limit => 10
    config.add_facet_field 'complete_facet',            :label => 'Reviewed',            :limit => 10
    config.add_facet_field 'reviewer_facet',            :label => 'Reviewer',            :limit => 10
    config.add_facet_field 'depositor_facet',           :label => 'Depositor',           :limit => 10
    config.add_facet_field 'converted_facet',           :label => 'Converted',           :limit => 10
    config.add_facet_field 'internal_series_facet',     :label => 'Internal Series',     :limit => 10
    config.add_facet_field 'internal_collection_facet', :label => 'Internal Collection', :limit => 10

    # TODO
    #config.add_facet_field 'event_date_dt', :label => 'Event Date', :query => {
    # :years_1 => { :label => 'within the last year', :fq => "event_date_dt:[#{Time.now.year - 1 } TO *]" },
    # :years_3 => { :label => 'within 3 years', :fq => "event_date_dt:[#{Time.now.year - 3 } TO *]" },
    # :years_5 => { :label => 'within 5 years', :fq => "event_date_dt:[#{Time.now.year - 5 } TO *]" },
    # :years_10 => { :label => 'within 10 years', :fq => "event_date_dt:[#{Time.now.year - 10 } TO *]" },
    # :years_15 => { :label => 'within 15 years', :fq => "event_date_dt:[#{Time.now.year - 15 } TO *]" },
    # :years_20 => { :label => 'within 20 years', :fq => "event_date_dt:[#{Time.now.year - 20 } TO *]" },
    # :years_25 => { :label => 'within 25 years', :fq => "event_date_dt:[#{Time.now.year - 25 } TO *]" }
    #}    

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'format',         :label => 'Format:'
    config.add_index_field 'title_display',  :label => 'Title:'
    config.add_index_field 'complete_facet', :label => 'Review Status:'


    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    #
    # These are fields that are shown via the catalog controller
    config.add_show_field 'format',                    :label => 'Format'
    config.add_show_field 'title_display',             :label => 'Main Title'
    config.add_show_field 'alternative_title_display', :label => 'Alternative Title'
    config.add_show_field 'chapter_display',           :label => 'Capter'
    config.add_show_field 'episode_display',           :label => 'Episode'
    config.add_show_field 'label_display',             :label => 'Label'
    config.add_show_field 'segment_display',           :label => 'Segment'
    config.add_show_field 'subtitle_display',          :label => 'Subtitle'
    config.add_show_field 'track_display',             :label => 'Track'
    config.add_show_field 'translation_display',       :label => 'Translation'
    config.add_show_field 'summary_display',           :label => 'Summary'
    config.add_show_field 'contents_display',          :label => 'Contents'
    config.add_show_field 'note_display',              :label => 'Note'
    config.add_show_field 'subject_facet',             :label => 'Subject'
    config.add_show_field 'genre_facet',               :label => 'Genre'
    config.add_show_field 'series_display',            :label => 'Event Series'
    config.add_show_field 'event_place_display',       :label => 'Event Place'
    config.add_show_field 'event_date_display',        :label => 'Event Date'
    config.add_show_field 'contributor_name_facet',    :label => 'Contributor', :helper_method => :contributor_display
    config.add_show_field 'publisher_name_facet',      :label => 'Publisher'
    config.add_show_field 'creation_date_display',     :label => 'Creation Date'
    config.add_show_field 'media_type_display',        :label => 'Media Type'
    config.add_show_field 'standard_display',          :label => 'Standard'
    config.add_show_field 'colors_display',            :label => 'Colors'
    config.add_show_field 'barcode_display',           :label => 'Barcode'
    config.add_show_field 'media_format_facet',        :label => 'Format'
    config.add_show_field 'generation_display',        :label => 'Generation'
    config.add_show_field 'language_display',          :label => 'Language'
    config.add_show_field 'repository_display',        :label => 'Repository'
    config.add_show_field 'collection_facet',          :label => 'Archival Collection'
    config.add_show_field 'archival_series_display',   :label => 'Archival Series'
    config.add_show_field 'collection_number_display', :label => 'Collection Number'
    config.add_show_field 'accession_number_display',  :label => 'Accession Number'
    config.add_show_field 'access_display',            :label => 'Usage'
    config.add_show_field 'condition_note_display',    :label => 'Condition Note'
    config.add_show_field 'cleaning_note_display',     :label => 'Cleaning Note'


    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', :label => 'All Fields'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.
      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        :qf => '$title_qf',
        :pf => '$title_pf'
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field('subject') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
      field.qt = 'search'
      field.solr_local_parameters = {
        :qf => '$subject_qf',
        :pf => '$subject_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc',             :label => 'relevance'
    config.add_sort_field 'system_create_dt asc',   :label => 'deposited (oldest first)'
    config.add_sort_field 'system_create_dt desc',  :label => 'deposited (newest first)'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  #
  # end of Blacklight configuration
  #
  #--------------------------------------------------------------------------------------


end
