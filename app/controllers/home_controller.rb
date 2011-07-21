class HomeController < ApplicationController
  def index
    @startpage_groups = Tag.startpage_groups
  end
end
