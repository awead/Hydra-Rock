# Overrides methods from Blacklight::BlacklightHelperBehavior

module LocalBlacklightHelper

  def application_name
    'Hydra'
  end

  # This is not working as it should be for some reason, so I'm overriding it:
  #
  # Return a normalized partial name that can be used to contruct view partial path
  def document_partial_name(document)
    # .to_s is necessary otherwise the default return value is not always a string
    # using "_" as sep. to more closely follow the views file naming conventions
    # parameterize uses "-" as the default sep. which throws errors
    display_type = document[blacklight_config.show.display_type]

    return 'default' unless display_type
    #display_type = display_type.join(" ") if display_type.respond_to?(:join)
    return display_type.parameterize("_")
    #{}"#{display_type.gsub("-"," ")}".parameterize("_").to_s
  end

  # Puts our title in a pretty little "well"
  def render_document_heading
    title = content_tag(:h2, @document[:heading_display].first) 
    content_tag(:div, title, :class => "well")
  end

end