class Tag
  include Mongoid::Document
  
  field :name, type: String
  field :startpage_group, type: Boolean, default: false
  index :startpage_group
  index :name

  scope :startpage_groups, where(startpage_group: true)
  
  validates_length_of :name, in: 1..50
  validates_format_of :name, :with => /[a-z1-9_!\-]+/
  
  def top_bookmarks
    # At first use all bookmarks tagged with "favourite"
    list = Bookmark.tagged_with_all([name, 'favourite']).rating_ordered
    
    # If there are less than ten bookmarks, fill the list up with other
    # well-rated bookmarks
    if list.size < 10
      list += Bookmark.tagged_with(name).not_in(id: list.collect(&:id))
        .rating_ordered.limit(10 - list.size)
    end
    
    # At last, sort again by rating, the favourites should not automatically be
    # on the top of the list.
    list.sort_by { |bookmark| -bookmark.rating }
  end
end
