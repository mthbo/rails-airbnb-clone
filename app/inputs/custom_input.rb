class CustomInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    symbol = options.delete(:symbol) || default_symbol
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    content_tag(:div, input_group(symbol, merged_input_options), class: "input-group")
  end

  private

  def input_group(symbol, merged_input_options)
    "#{symbol_addon(symbol)} #{@builder.text_field(attribute_name, merged_input_options)}".html_safe
  end

  def symbol_addon(symbol)
    content_tag(:span, symbol, class: "input-group-addon custom-input-addon")
  end

  def default_symbol
    ""
  end
end
