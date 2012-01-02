describe UrlInfos do
  let(:url_infos) { Bookmark.new(url: 'http://rubygems.org').url_infos }
  it 'is initially not fetched' do
    url_infos.fetched.should be_false
    url_infos.title.should be_nil
  end
  context 'with fetched data' do
    before { url_infos.fetch }
    it 'has a favicon URL set' do
      url_infos.favicon_url.should == 'http://rubygems.org/favicon.ico'
    end
    it 'has the title set' do
      url_infos.title =~ /rubygems/i
    end
  end
end

