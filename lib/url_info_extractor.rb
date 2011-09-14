# TODO: Error handling all over the class
class UrlInfoExtractor
  def initialize url
    @uri = URI.parse(url)
    @path = @uri.path
    @path = '/' if @path.empty?
  end
  
  # Note: You can unlink the favicon file after usage
  def run
    # Only HTTP- or HTTPS-based URLs
    unless %w(http https).include?(@uri.scheme)
      # TODO: Return anything other?
      return nil
    end
    
    # Only process mime type "text/html"
    # TODO: More mime types?
    unless do_http_request(@path, :head).content_type == 'text/html'
      return nil
    end
    
    data = extract_html_data
    favicon_url = calc_favicon_url data[:favicon], data[:base]
    filename = fetch_favicon favicon_url
    
    data.merge favicon_tempfile_name: filename
  end
  
  private

  # Extract title, keywords, description, favicon, base
  def extract_html_data
    doc = Nokogiri::HTML(do_http_request(@path, :get).body)
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
    Tempfile.new(['oreidig_favicon_', '.ico'], Rails.root.join('tmp')) do |f|
      f.binmode
      f.write(do_http_request(url, :get).body)
      f.close
    end
  end

  def do_http_request path, method
    request = "Net::HTTP::#{method.to_s.camelize}".constantize.new(path)
    Net::HTTP.start(@uri.host, @uri.port) do |http|
      http.request request
    end
  end

end