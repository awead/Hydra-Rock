module LocalHydraFedoraMetadataHelper

  include Hydra::HydraFedoraMetadataHelperBehavior
  include Hydra::HydraHelperBehavior

  # Overriding fedora_text_field method
  def fedora_text_field(resource, datastream_name, field_key, opts={})
    field_name = field_name_for(field_key)

    field_values = get_values_from_datastream(resource, datastream_name, field_key, opts)
    if opts.fetch(:multiple, true) and field_values.first != ""
      field_values.push("")
    else
      field_values.empty? ? field_values = [""] : [field_values.first]
    end

    required = opts.fetch(:required, true) ? "required" : ""

    body = ""

    field_values.each_with_index do |current_value, z|
      base_id = generate_base_id(field_name, current_value, field_values, opts)
      name = "asset[#{datastream_name}][#{field_name}][#{z}]"
        body << "<input class=\"editable-edit edit\" id=\"#{base_id}\" data-datastream-name=\"#{datastream_name}\" name=\"#{name}\" value=\"#{sanitize(current_value.strip)}\" #{required} type=\"text\" />"
        body << "<a href=\"\" title=\"Delete '#{sanitize(current_value)}'\" class=\"destructive field\">Delete</a>" if opts.fetch(:multiple, true) && !current_value.empty?
        body << "<br/>" if opts.fetch(:multiple, true)
    end

    result = field_selectors_for(datastream_name, field_key)
    result << body.html_safe

    result
  end

end