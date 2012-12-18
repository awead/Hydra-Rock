# Overrides methods from Blacklight::BlacklightHelperBehavior

module LocalBlacklightHelper

  def application_name
    'Hydra'
  end

  def field_value_separator
    '<br/>'
  end

end