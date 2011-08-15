module Jqm
  module Helper

    def self.included base
      Jqm.source_files
    end

    def jqm_context name
      old_context = Jqm::Stylesheet.actual_context
      Jqm::Stylesheet.actual_context = name
      yield
      Jqm::Stylesheet.actual_context = old_context
    end

    # Uses haml_tag exclusive
    def jqm method, options = {}, &blck
      style = Stylesheet

      data = style.contexts.fetch(style.actual_context)[method]
      temp_data = data.clone
      tag = temp_data.delete :tag
      full_options = options.deep_merge({:data => data})

      haml_tag tag, full_options, &blck
    end

  end
end

if Rails.env == "development"
  unloadable Jqm::Helper
end
