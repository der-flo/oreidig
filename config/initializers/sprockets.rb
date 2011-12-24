# TODO Flo: Blog this solution
clz = Oreidig::Application.assets.context_class
clz.instance_eval do
  include Oreidig::Application.routes.url_helpers
  cattr_reader :default_url_options
end

# prevent "warning: class variable access from toplevel"
clz.class_variable_set '@@default_url_options', {
                         host: Oreidig::Application.config.url_options.host,
                         port: Oreidig::Application.config.url_options.port
                       }
