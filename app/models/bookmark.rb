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
  field :url_infos, type: Hash # TODO: private field?
  field :clicks, type: Array, default: []
  field :rating, type: Integer, default: 0

  scope :rating_ordered, order_by(:rating, :desc)

  # Validations
  validates :notes, length: { maximum: 5_000 }
  validates :url, url: true, presence: true,
            length: { in: 1..250, allow_blank: true }
  validates :title, presence: true, length: { in: 1..250, allow_blank: true }
  validates_with TagsValidator

  # Configuration of full-text search
  search_in :title, :url, :notes, :tags_array

  # Callbacks
  before_save :create_tag_objects, :if => :tags_array_changed?

  # Prefix URL with "http://" if no protocol specified
  def url= url
    url = "http://#{url}" unless url =~ /^([a-z]+):\/\//
    write_attribute :url, url
  end

  # Save title, keywords, description and favicon
  def fetch_url_infos
    # TODO: Do not save all data
    self.url_infos = UrlInfoExtractor.new(url).run
    dest_filename = Rails.root.join('public', 'favicon_store', "#{id}.ico")
    FileUtils.cp(url_infos[:favicon_filename], dest_filename)
    FileUtils.rm(url_infos[:favicon_filename])
  end

  def click!
    clicks << Time.now
    recalc_rating
    save
  end

  private

  # TODO: Call daily for every bookmark
  def recalc_rating
    # Simple rating algorithm
    self.rating = clicks.inject(0) do |sum, time|
      case time.utc.to_i
      when gen_time_range(-1.day, 0.seconds) then 100
      when gen_time_range(-1.week, -1.day) then 10
      when gen_time_range(-1.month, -1.week) then 2
      else 1
      end + sum
    end

    # Remove old and irrelevant click entries
    clicks.keep_if { |time| time.utc > Time.now.utc - 6.months }

    self.rating
  end

  def create_tag_objects
    tags_array.each do |tag|
      Tag.find_or_create_by name: tag
    end
  end

  def gen_time_range t1, t2
    (Time.now.utc + t1).to_i..(Time.now.utc + t2).to_i
  end

  def self.hot count = 20
    # TODO: Implement something, to get the hottest links
    all.rating_ordered.limit(count)
  end

  def self.most_recent count = 20
    all.order_by(:created_at).limit(count)
  end

end

# Examples:
# Bookmark.tagged_with_all(['bla', 'dings']).csearch('oreidig').first
