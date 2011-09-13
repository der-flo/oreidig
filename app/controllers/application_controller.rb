class ApplicationController < ActionController::Base
  before_filter :prepend_controller_view_path
  protect_from_forgery
  helper ::Jqm::Helper

  def prepend_controller_view_path
    # TODO Sven: Why is this needed? (Flo)
    prepend_view_path Rails.root + "/app/views/#{controller_name}"
  end
end
