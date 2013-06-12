module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
    results = String.new
    results << '<div class="alert">'
    results << content_tag(:strong, sentence)
    results << "<ul>"
    results << messages
    results << "</ul>"
    results << '</div>'
    return results.html_safe
  end
end