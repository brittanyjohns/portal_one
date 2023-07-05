module PromptsHelper
  def form_links(form, image_types, input_id = nil)
    link_list = []
    image_types.each do |image_type|
      input_id ||= image_type.downcase
      link_list << form.submit(image_type, id: input_id, class: "btn btn-dark")
    end
    link_list.join("").html_safe
  end
end
