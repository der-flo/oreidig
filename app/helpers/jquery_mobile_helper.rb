module JqueryMobileHelper

  def single_page!
    content_for :page_type, "type-index"
  end

  def multi_page!
    content_for :page_type, "type-interior"
  end

  def page_type
    multi_page! unless content_for? :page_type
    content_for :page_type
  end

  def multipage?
    page_type == "type-interior"
  end

end
