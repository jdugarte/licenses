module ApplicationHelper

  def error_messages(object)
    if object.errors.any?
      content_tag :div, :id => "error_explanation" do
        concat content_tag :h2, "#{pluralize(object.errors.count, 'error')} prohibited this #{object.class.name.downcase} from being saved:"
        ul_elem = content_tag :ul do
          list = object.errors.full_messages.reduce(''.html_safe) do |html, msg|
            html << content_tag(:li, msg)
          end
          concat list
        end
        concat ul_elem
      end
    else
      ""
    end
  end
  
end
