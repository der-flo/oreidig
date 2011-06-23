class Bookmark
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Taggable
  include Mongoid::Search

  field :title, type: String
  field :url, type: String
  field :notes, type: String
  field :tags, type: Array

  validates_presence_of :title, :url
  validates_length_of :title, :url, in: 1..250, allow_blank: true
  validates_length_of :notes, maximum: 5_000
  
  # TODO: Validate url format
  # TODO: Validate tags, see tag.rb
  
  search_in :title, :url, :notes, :tags_array

end

# Examples:
# Bookmark.tagged_with_all(['bla', 'dings']).csearch('oreidig').first