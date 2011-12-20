module LocalHydraFedoraMetadataHelper

  include Hydra::HydraFedoraMetadataHelperBehavior

  # This is based on fedora_text_field
  def local_fedora_text_field(resource, datastream_name, field_key, opts={})
    field_name = field_name_for(field_key)
    field_values = get_values_from_datastream(resource, datastream_name, field_key, opts)
    field_values = [""] if field_values.empty?
    field_values = [field_values.first] unless opts.fetch(:multiple, true)

    required = opts.fetch(:required, true) ? "required" : ""
    opts[:size] ? input_size = opts[:size] : input_size = 20

    if !field_values[0].empty? and opts.fetch(:multiple, true)
      field_values.push("")
    end

    body = ""
    body << "<ol>"
    field_values.each_with_index do |current_value, z|
      base_id = generate_base_id(field_name, current_value, field_values, opts)
      name = "asset[#{datastream_name}][#{field_name}][#{z}]"
      body << "<li>"
      body << "<input class=\"editable-edit edit\" size=\"#{input_size.to_s}\" id=\"#{base_id}\" data-datastream-name=\"#{datastream_name}\" name=\"#{name}\" value=\"#{sanitize(current_value.strip)}\" #{required} type=\"text\" />"
      body << "</li>"
    end
    body << "</ol>"

    result = field_selectors_for(datastream_name, field_key)
    result << body.html_safe
    return result
  end

end