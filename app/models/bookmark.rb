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
  field :tags, type: Array

  # Validations
  validates :notes, length: { maximum: 5_000 }
  validates :url, url: true, presence: true,
            length: { in: 1..250, allow_blank: true }
  validates :title, presence: true, length: { in: 1..250, allow_blank: true }
  validates_with TagsValidator

  # Configuration of full-text search
  search_in :title, :url, :notes, :tags_array
  
  # Prefix URL with "http://" if no protocol specified
  def url= url
    url = "http://#{url}" unless url =~ /^([a-z]+):\/\//
    write_attribute :url, url
  end

end

# Examples:
# Bookmark.tagged_with_all(['bla', 'dings']).csearch('oreidig').first
