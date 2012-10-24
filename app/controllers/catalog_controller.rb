class CatalogController < ApplicationController

  include Blacklight::Catalog
  include Hydra::AccessControlsEnforcement
  include Rockhall::Controller::ControllerBehavior

  # User still needs the #update action in the catalog, so we only enforce Hydra
  # access controls when the user tries to just view a document they don't have
  # access to.
  before_filter :enforce_access_controls, :only=>:show

  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic << :add_access_controls_to_solr_params
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic << :exclude_unwanted_models

  #--------------------------------------------------------------------------------------
  #
  # Blacklight configuriation
  #

  configure_blacklight do |config|
    config.default_solr_params = {
      :qt   => 'search',
      :rows => 10,
      :fq   => ["-has_model_s:\"info:fedora/afmodel:ExternalVideo\""]
    }

    # solr field configuration for search results/index views
    config.index.show_link            = 'heading_display'
    config.index.record_display_type  = 'format'

    # solr field configuration for document/show views
    config.show.html_title            = 'title_t'
    config.show.heading               = 'title_t'

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
    config.add_facet_field 'format',              :label => 'Content Type'
    config.add_facet_field 'format_facet',        :label => 'Media Format'
    config.add_facet_field 'name_facet',          :label => 'Name'
    config.add_facet_field 'subject_topic_facet', :label => 'Topic'
    config.add_facet_field 'genre_facet',         :label => 'Genre'
    config.add_facet_field 'series_facet',        :label => 'Event/Series'
    config.add_facet_field 'collection_facet',    :label => 'Collection'
    config.add_facet_field 'language_facet',      :label => 'Language',     :limit => true
    config.add_facet_field 'complete_t',          :label => 'Review Status'
    config.add_facet_field 'create_date_facet',   :label => 'Year'
    config.add_facet_field 'priority_t',          :label => 'Priority'
    config.add_facet_field 'depositor_facet',     :label => 'Depositor'
    config.add_facet_field 'reviewer_facet',      :label => 'Reviewer'

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    #use this instead if you don't want to query facets marked :show=>false
    #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'format',                 :label => 'Format:'
    config.add_index_field 'alternative_title_t',    :label => 'Alternative Title'
    config.add_index_field 'event_series_t',         :label => 'Event Series'
    config.add_index_field 'event_date_t',           :label => 'Event Date'
    config.add_index_field 'creation_date_t',        :label => 'Creation Date'
    config.add_index_field 'media_type_t',           :label => 'Media Type'
    config.add_index_field 'archival_collection_t',  :label => 'Archival Collection'
    config.add_index_field 'archival_series_t',      :label => 'Archival Series'


    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    #
    # These are fields that are shown via the catalog controller
    config.add_show_field 'format',                 :label => 'Format'
    config.add_show_field 'main_title_t',           :label => 'Main Title'
    config.add_show_field 'alternative_title_t',    :label => 'Alternative Title'
    config.add_show_field 'chapter_t',              :label => 'Capter'
    config.add_show_field 'episode_t',              :label => 'Episode'
    config.add_show_field 'label_t',                :label => 'Label'
    config.add_show_field 'segment_t',              :label => 'Segment'
    config.add_show_field 'subtitle_t',             :label => 'Subtitle'
    config.add_show_field 'track_t',                :label => 'Track'
    config.add_show_field 'translation_t',          :label => 'Translation'
    config.add_show_field 'summary_t',              :label => 'Summary'
    config.add_show_field 'parts_list_t',           :label => 'Parts List'
    config.add_show_field 'note_t',                 :label => 'Note'
    config.add_show_field 'subjects_t',             :label => 'Subject'
    config.add_show_field 'genres_t',               :label => 'Genre'
    config.add_show_field 'event_series_t',         :label => 'Event Series'
    config.add_show_field 'event_place_t',          :label => 'Event Place'
    config.add_show_field 'event_date_t',           :label => 'Event Date'
    config.add_show_field 'contributors_display',   :label => 'Contributor'
    config.add_show_field 'publisher_display',      :label => 'Publisher'
    config.add_show_field 'creation_date_t',        :label => 'Creation Date'
    config.add_show_field 'media_type_t',           :label => 'Media Type'
    config.add_show_field 'standard_t',             :label => 'Standard'
    config.add_show_field 'colors_t',               :label => 'Colors'
    config.add_show_field 'barcode_t',              :label => 'Barcode'
    config.add_show_field 'format_t',               :label => 'Format'
    config.add_show_field 'generation_t',           :label => 'Generation'
    config.add_show_field 'language_t',             :label => 'Language'
    config.add_show_field 'repository_t',           :label => 'Repository'
    config.add_show_field 'archival_collection_t',  :label => 'Archival Collection'
    config.add_show_field 'archival_series_t',      :label => 'Archival Series'
    config.add_show_field 'collection_number_t',    :label => 'Collection Number'
    config.add_show_field 'accession_number_t',     :label => 'Accession Number'
    config.add_show_field 'usage_t',                :label => 'Usage'
    config.add_show_field 'condition_note_t',       :label => 'Condition Note'
    config.add_show_field 'cleaning_note_t',        :label => 'Cleaning Note'


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

    config.add_search_field('author') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
      field.solr_local_parameters = {
        :qf => '$author_qf',
        :pf => '$author_pf'
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
