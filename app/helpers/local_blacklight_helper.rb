# Overrides methods from Blacklight::BlacklightHelperBehavior

module LocalBlacklightHelper

  include Blacklight::BlacklightHelperBehavior

  def application_name
    'Hydra'
  end

  def field_value_separator
    '<br/>'.html_safe
  end

end