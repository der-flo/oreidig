class Tag
  include Mongoid::Document
  
  field :name, type: String
  field :startpage_group, type: Boolean
  
  validates_length_of :name, in: 1..50
  validates_format_of :name, :with => /[a-z1-9_!\-]+/
end