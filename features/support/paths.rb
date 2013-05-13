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

    # Archival videos
    when /show archival video page for (.*)/i
      catalog_path($1)
    when /new archival video page/
      new_archival_video_path
    when /edit archival video page for (.*)/i
      edit_archival_video_path($1)
    when /the (.+) workflow page for (.+)/
      workflow_archival_video_path($2, $1)

    # External videos
    when /edit external video page for (.*)/i
      edit_external_video_path($1)   
    when /new tape page for (.*)/i
      new_archival_video_external_video_path($1) 

    # Archival collections
    when /new archival_collection/
      new_archival_collection_path

    # Activities
    when /the activities page$/i
      activities_path
    when /the activities page for user (.*)$/i
      user_path($1)
    
    # Try and figure it out, or report an error
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
