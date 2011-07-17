class Bookmark
  # Mongoid extensions
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  include Mongoid::Search

  # MongoDB fields
  field :title, type: String
  field :url, type: String
  field :notes, type: String
  field :url_infos, type: Hash
  
  # TODO: Private?
  # field :favicon_fetched, type: Boolean

  # Validations
  validates :notes, length: { maximum: 5_000 }
  validates :url, url: true, presence: true,
            length: { in: 1..250, allow_blank: true }
  validates :title, presence: true, length: { in: 1..250, allow_blank: true }
  validates_with TagsValidator

  # Configuration of full-text search
  search_in :title, :url, :notes, :tags_array
  
  # Callbacks
  after_save :create_tag_objects
  
  # Prefix URL with "http://" if no protocol specified
  def url= url
    url = "http://#{url}" unless url =~ /^([a-z]+):\/\//
    write_attribute :url, url
  end
  
  # TODO: Save title, keywords, description and favicon
  def fetch_url_infos
    # TODO: Do not save all data
    self.url_infos = UrlInfoExtractor.new(url).run
    dest_filename = Rails.root.join('public', 'favicon_store', "#{id}.ico")
    FileUtils.cp(url_infos[:favicon_filename], dest_filename)
    FileUtils.rm(url_infos[:favicon_filename])
  end
  
  private
  
  def create_tag_objects
    tags_array.each do |tag|
      Tag.find_or_create_by name: tag
    end
  end
  
end

# Examples:
# Bookmark.tagged_with_all(['bla', 'dings']).csearch('oreidig').first
