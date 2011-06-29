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

  def listview data, &block
    data[:role] = :listview
    jqm_tag :ul, data, {} , block
  end

  def jqm_tag tag, data_attrs, attrs = {}
    attrs.merge!({:data => data_attrs})
    haml_tag tag, attrs do
      yield if block_given?
    end
  end

end
