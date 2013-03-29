module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)

    case page_name

    when /the home\s?page/
      '/'
    when /the search page/
      '/catalog'
    when /logout/
      destroy_user_session_path
    when /my account info/
      edit_user_registration_path
    when /the base search page/
      '/catalog?q=&search_field=search&action=index&controller=catalog&commit=search'
    when /the document page for id (.+)/
      catalog_path($1)
    when /the edit page for id (.+)/
      edit_catalog_path($1)
    when /the catalog index page/
      catalog_index_path

    # Workflow steps
    when /the first workflow edit page for (.+)/
      edit_catalog_path($1)
    when /the subjects workflow edit page for (.+)/
      edit_catalog_path(:id => $1, :wf_step => "subjects")
    when /the persons workflow edit page for (.+)/
      edit_catalog_path(:id => $1, :wf_step => "persons")

    when /the edit document page for (.*)$/i
      edit_catalog_path($1)
    when /the show document page for (.*)$/i
      catalog_path($1)
    when /the review document page for (.*)$/i
      edit_reviewer_path($1)
    when /the delete confirmation page for (.*)$/i
      delete_catalog_path($1)

    when /the file (?:asset )?list page for (.*)$/i
      asset_file_assets_path($1)
    when /the file asset creation page for (.*)$/i
      asset_file_assets_path($1)
    when /the deletable file list page for (.*)/i
      asset_file_assets_path($1, :deletable=>"true",:layout=>"false")
    when /the file asset (.*) with (.*) as its container$/i
      asset_file_asset_path($2, $1)
    when /the file asset (.*)$/i
      file_asset_path($1)
    when /the permissions page for (.*)$/i
      asset_permissions_path($1)

    # Archival videos
    when /show archival video page for (.*)/i
      catalog_path($1)
    when /new archival video page/
      new_archival_video_path
    when /edit archival video page for (.*)/i
      edit_archival_video_path($1)

    # External Videos
    when /show external video page for (.*)/i
      catalog_path($1)

    # Digital Videos
    when /new digital_video page/
      new_digital_video_path
    when /show digital video page for (.*)/i
      catalog_path($1)
    when /edit digital video page for (.*)/i
      edit_digital_video_path($1)

    when /new archival_collection/
      new_archival_collection_path

    when /new (.*) page$/i
      new_asset_path(:content_type => $1)
    when /the asset (.*)$/i
      asset_path($1)
    when /show asset page for (.*)$/i
      asset_path($1)


    when /the (\d+)(?:st|nd|rd|th) (person|organization|conference) entry in (.*)$/i
      # contributor_id = "#{$2}_#{$1.to_i-1}"
      asset_contributor_path($3, $2, $1.to_i-1, :content_type=>"mods_asset")

    when /the edit (.*) page for (.*)$/i
      edit_catalog_path($2,:wf_step=>$1)
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end

  end

end

World(NavigationHelpers)
