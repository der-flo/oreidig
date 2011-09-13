# TODO Flo: Blog this solution
Oreidig::Application.assets.context_class.instance_eval do
  include Rails.application.routes.url_helpers
  cattr_reader :default_url_options
  # TODO Flo: warning: class variable access from toplevel
  @@default_url_options = {
    host: Settings.url_options.host,
    port: Settings.url_options.port,
    protocol: Settings.url_options.protocol
  }
end
