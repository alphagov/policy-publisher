class AdminFormBuilder < GenericFormBuilder
  STANDARD_FIELDS.each do |method|
    define_method(method.to_sym) do |field, *args|
      options, *args = args
      options ||= {}

      options[:wrapper_html_options] = {class: "form-group"}.merge(options[:wrapper_html_options] || {})
      options[:class] = Array(options[:class]) + ["form-control", "input-md-4"]

      super(field, options, *args)
    end
  end

  def buttons(options)
    super(options.merge(
      button_class: %w( btn btn-success ),
      cancel_class: %w( btn btn-link )
    ))
  end
end
