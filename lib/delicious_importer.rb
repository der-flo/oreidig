require 'open-uri'

module DeliciousImporter
  def self.import_all
    # clear database
    Bookmark.destroy_all
    
    str = fetch_data
    data = Hash.from_xml(str)
    data['posts']['post'].each do |post|
      import_single_bookmark(post)
    end
  end

  private

  def self.fetch_data
    conf = YAML.load(File.read(Rails.root.join('config', 'delicious.yml')))
    
    open('https://api.del.icio.us/v1/posts/all', #'?results=10',
         http_basic_authentication: [conf['username'], conf['password']],
         'User-Agent' => 'oreidig-importer',
         ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
  end
  
  def self.import_single_bookmark post
    tags = post['tag'].split(' ')
    Bookmark.create! do |b|
      b.title = post['description']
      b.url = post['href']
      b.notes = post['extended']
      b.tags_array = tags
      b.created_at = Time.parse(post['time'])
      b.updated_at = Time.parse(post['time'])
    end
  rescue StandardError => err
    puts err
  end
end
