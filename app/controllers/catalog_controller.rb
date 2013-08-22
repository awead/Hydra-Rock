class CatalogController < ApplicationController

  include Blacklight::Catalog
  include Rockhall::Controller::ControllerBehavior
  include Rockhall::Exports

  before_filter :enforce_show_permissions, :only=>:show
  before_filter :get_af_doc, :only => :show
  before_filter :get_public_activity, :only => :index

  # This applies appropriate access controls to all solr queries
  CatalogController.solr_search_params_logic += [:add_access_controls_to_solr_params]
  # This filters out objects that you want to exclude from search results, like FileAssets
  CatalogController.solr_search_params_logic += [:exclude_unwanted_models]

  SolrDocument.use_extension ::Rockhall::Exports

  #--------------------------------------------------------------------------------------
  #
  # Blacklight configuriation
  #

  configure_blacklight do |config|
    config.default_solr_params = {
      :qt   => 'search',
      :rows => 10
    }

    # solr field configuration for search results/index views
    config.index.show_link            = 'title_ssm'
    config.index.record_display_type  = 'format_ssm'

    # solr field configuration for document/show views
    config.show.html_title            = 'title_ssm'
    config.show.heading               = 'title_ssm'

    # This is the field that's used to determine the partial type
    config.show.display_type          = 'format_ssm'

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
    config.add_facet_field solr_name('format', :facetable),              :label => 'Media Type',          :limit => 10
    config.add_facet_field solr_name('media_format', :facetable),        :label => 'Physical Format',     :limit => 10
    config.add_facet_field solr_name('contributor_name', :facetable),    :label => 'Name',                :limit => 10
    config.add_facet_field solr_name('subject', :facetable),             :label => 'Subject',             :limit => 10
    config.add_facet_field solr_name('genre', :facetable),               :label => 'Genre',               :limit => 10
    config.add_facet_field solr_name('series', :facetable),              :label => 'Event/Series',        :limit => 10
    config.add_facet_field solr_name('collection', :facetable),          :label => 'Collection',          :limit => 10  
    config.add_facet_field solr_name('create_date', :facetable),         :label => 'Creation Date',       :limit => 10
    config.add_facet_field solr_name('language', :facetable),            :label => 'Language',            :limit => true
    config.add_facet_field solr_name('priority', :facetable),            :label => 'Priority',            :limit => 10
    config.add_facet_field solr_name('complete', :facetable),            :label => 'Reviewed',            :limit => 10
    config.add_facet_field solr_name('reviewer', :facetable),            :label => 'Reviewer',            :limit => 10
    config.add_facet_field solr_name('depositor', :facetable),           :label => 'Depositor',           :limit => 10
    config.add_facet_field solr_name('converted', :facetable),           :label => 'Converted',           :limit => 10
    config.add_facet_field solr_name('internal_series', :facetable),     :label => 'Internal Series',     :limit => 10
    config.add_facet_field solr_name('internal_collection', :facetable), :label => 'Internal Collection', :limit => 10

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
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    #use this instead if you don't want to query facets marked :show=>false
    #config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field solr_name('format', :displayable),   :label => 'Format:'
    config.add_index_field solr_name('title', :displayable),    :label => 'Title:'
    config.add_index_field solr_name('complete', :displayable), :label => 'Review Status:'


    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    #
    # These are fields that are shown via the catalog controller
    config.add_show_field solr_name('format', :displayable),            :label => 'Format'
    config.add_show_field solr_name('title', :displayable),             :label => 'Main Title'
    config.add_show_field solr_name('alternative_title', :displayable), :label => 'Alternative Title'
    config.add_show_field solr_name('chapter', :displayable),           :label => 'Capter'
    config.add_show_field solr_name('episode', :displayable),           :label => 'Episode'
    config.add_show_field solr_name('label', :displayable),             :label => 'Label'
    config.add_show_field solr_name('segment', :displayable),           :label => 'Segment'
    config.add_show_field solr_name('subtitle', :displayable),          :label => 'Subtitle'
    config.add_show_field solr_name('track', :displayable),             :label => 'Track'
    config.add_show_field solr_name('translation', :displayable),       :label => 'Translation'
    config.add_show_field solr_name('summary', :displayable),           :label => 'Summary'
    config.add_show_field solr_name('contents', :displayable),          :label => 'Contents'
    config.add_show_field solr_name('note', :displayable),              :label => 'Note'
    config.add_show_field solr_name('subject', :displayable),           :label => 'Subject'
    config.add_show_field solr_name('genre', :displayable),             :label => 'Genre'
    config.add_show_field solr_name('series', :displayable),            :label => 'Event Series'
    config.add_show_field solr_name('event_place', :displayable),       :label => 'Event Place'
    config.add_show_field solr_name('event_date', :displayable),        :label => 'Event Date'
    config.add_show_field solr_name('contributor_name', :displayable),  :label => 'Contributor', :helper_method => :contributor_display
    config.add_show_field solr_name('publisher_name', :displayable),    :label => 'Publisher'
    config.add_show_field solr_name('creation_date', :displayable),     :label => 'Creation Date'
    config.add_show_field solr_name('media_type', :displayable),        :label => 'Media Type'
    config.add_show_field solr_name('standard', :displayable),          :label => 'Standard'
    config.add_show_field solr_name('colors', :displayable),            :label => 'Colors'
    config.add_show_field solr_name('barcode', :displayable),           :label => 'Barcode'
    config.add_show_field solr_name('media_format', :displayable),      :label => 'Format'
    config.add_show_field solr_name('generation', :displayable),        :label => 'Generation'
    config.add_show_field solr_name('language', :displayable),          :label => 'Language'
    config.add_show_field solr_name('repository', :displayable),        :label => 'Repository'
    config.add_show_field solr_name('collection', :displayable),        :label => 'Archival Collection'
    config.add_show_field solr_name('archival_series', :displayable),   :label => 'Archival Series'
    config.add_show_field solr_name('collection_number', :displayable), :label => 'Collection Number'
    config.add_show_field solr_name('accession_number', :displayable),  :label => 'Accession Number'
    config.add_show_field solr_name('access', :displayable),            :label => 'Usage'
    config.add_show_field solr_name('condition_note', :displayable),    :label => 'Condition Note'
    config.add_show_field solr_name('cleaning_note', :displayable),     :label => 'Cleaning Note'


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

    # :solr_local_parameters will be sent using Solr LocalParams
    # syntax, as eg {! qf=$title_qf }. This is neccesary to use
    # Solr parameter de-referencing like $title_qf.
    # See: http://wiki.apache.org/solr/LocalParams
    config.add_search_field('title') do |field|
      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }
      field.solr_local_parameters = {
        :qf => '$title_qf',
        :pf => '$title_pf'
      }
    end

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
    config.add_sort_field 'score desc, title_si asc', :label => 'relevance'
    config.add_sort_field 'system_create_dtsi asc',       :label => 'deposited (oldest first)'
    config.add_sort_field 'system_create_dtsi desc',      :label => 'deposited (newest first)'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  #
  # end of Blacklight configuration
  #
  #--------------------------------------------------------------------------------------


end
