class Tag
  include Mongoid::Document
  
  field :name, type: String
  field :startpage_group, type: Boolean, default: false
  index :startpage_group
  index :name

  scope :startpage_groups, where(startpage_group: true)
  
  validates_length_of :name, in: 1..50
  validates_format_of :name, :with => /[a-z1-9_!\-]+/
  
  def top_ten_bookmarks
    Bookmark.tagged_with(name).rating_ordered.limit(10)
  end
end
