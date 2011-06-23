class Bookmark
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :url, type: String
  field :notes, type: String
  field :tags, type: Array
  
  validates_presence_of :title, :url
  validates_length_of :title, :url, in: 1..250, allow_blank: true
  validates_length_of :notes, maximum: 5_000
  
  # TODO: Validate tags
end
