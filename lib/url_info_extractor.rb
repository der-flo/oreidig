class UrlInfoExtractor
  def initialize url
    @uri = URI.parse(url)
  end
  
  # Note: You can unlink the favicon file after usage
  def run
    # TODO: private etc.
    
    # Only HTTP- or HTTPS-based URLs
    unless %w(http https).include?(@uri.scheme)
      # TODO: Return anything other?
      return nil
    end
    
    # Only process mime type "text/html"
    # TODO: More mime types?
    mime_type = request_mime_type
    unless mime_type == 'text/html'
      return nil
    end
    
    data = extract_html_data
    favicon_url = calc_favicon_url data[:favicon], data[:base]
    filename = fetch_favicon favicon_url
    
    data.merge favicon_filename: filename
  end
  
  private
  
  # TODO: Refactor duplication

  def request_mime_type
    # TODO: Error handling
    path = @uri.path
    path = '/' if path.empty?
    request = Net::HTTP::Head.new(path)
    response = Net::HTTP.start(@uri.host, @uri.port) do |http|
      http.request request
    end
    response.content_type
  end
  
  def full_get_request
    # TODO: Error handling
    path = @uri.path
    path = '/' if path.empty?
    request = Net::HTTP::Get.new(path)
    response = Net::HTTP.start(@uri.host, @uri.port) do |http|
      http.request request
    end
    response.body
  end
  
  def extract_html_data
    body = full_get_request

    # Extract title, keywords, description, favicon, base
    # TODO: Error handling
    doc = Nokogiri::HTML(body)
    head = doc.css('html head')
    
    {
      title: head.css('title').try(:first).try(:content),
      keywords: head.css('meta[name=keywords]').try(:first).try(:[], 'content'),
      description:
        head.css('meta[name=description]').try(:first).try(:[], 'content'),
      favicon: head.css('link[rel=icon]').try(:first).try(:[], 'href'),
      base: head.css('base').try(:first).try(:[], 'href')
    }
  end
  
  def calc_favicon_url favicon_url, base_url
    # TODO: Handle base
    
    # three cases
    case favicon_url
    when /^([a-z]+):\/\//
      # absolute URL with scheme
      favicon_url
    when /^\//
      # absolute URL without scheme
      uri = @uri.dup
      # TODO: Handle query string etc.
      uri.path = favicon_url
      uri.to_s
    else
      # relative URL
      uri = @uri.dup
      # TODO: Handle query string etc.
      # TODO: Normalize URL
      uri.path += favicon_url
      uri.to_s
    end
  end
  
  def fetch_favicon url
    file = fetch_url_into_file(url) if url.present?
    
    file ||= begin
      # Try default URL
      uri = @uri.dup
      # TODO: Handle query string etc.
      uri.path = 'favicon.ico'
      fetch_url_into_file uri.to_s
    end
    
    file.path
  end
  
  def fetch_url_into_file url
    # TODO: Error handling
    request = Net::HTTP::Get.new(url)
    response = Net::HTTP.start(@uri.host, @uri.port) do |http|
      http.request request
    end
    
    file = Tempfile.new(['oreidig_favicon', '.ico'],
                        Rails.root.join('tmp'))
    file.binmode
    file.write(response.body)
    file.close
    file
  end
end