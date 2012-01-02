class UrlInfos
  include Mongoid::Document
  embedded_in :bookmark
  
  # MongoDB fields
  field :title, type: String
  field :description, type: String
  field :fetched, type: Boolean, default: false
  field :favicon_url, type: String

  def has_favicon?
    favicon_url.present?
  end

  # Fetch title, keywords, description and favicon
  def fetch
    # TODO Flo: Async etc.?
    infos = UrlInfoExtractor.new(bookmark.url)
    self.fetched = true

    self.title = infos.title
    self.description = infos.description
    self.favicon_url = infos.favicon_url
    # TODO Flo: Check existance of favicon?

    self
  end
end

