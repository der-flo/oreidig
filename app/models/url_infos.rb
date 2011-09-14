class UrlInfos
  include Mongoid::Document
  embedded_in :bookmark
  
  # MongoDB fields
  field :title, type: String
  field :keywords, type: String
  field :description, type: String
  field :fetched, type: Boolean, default: false
  field :has_favicon, type: Boolean
  
  # Callbacks
  after_destroy :delete_favicon

  # Fetch title, keywords, description and favicon
  def fetch
    # TODO Flo: Async etc.?
    data = UrlInfoExtractor.new(bookmark.url).run
    self.fetched = true
    
    if data
      self.title = data[:title]
      self.keywords = data[:keywords]
      self.description = data[:description]

      if fn = data[:favicon_tempfile_name]
        FileUtils.cp(fn, favicon_path)
        FileUtils.rm(fn)
        self.has_favicon = true
      end
    end
    
    self
  end

  private

  def favicon_path
    Rails.root.join('public', 'favicon_store', "#{id}.ico")
  end
  
  def delete_favicon
    FileUtils.rm favicon_path
  end

end