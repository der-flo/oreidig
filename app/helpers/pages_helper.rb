module PagesHelper
  
  def popup_bookmarklet_js
    # http://blog.phusion.nl/2011/08/14/rendering-rails-3-1-assets-to-string/
    # TODO: Compression enabled in production?
    Oreidig::Application.assets.find_asset('bookmarklets/popup.js').body
  end
  def fullscreen_bookmarklet_js
    Oreidig::Application.assets.find_asset('bookmarklets/fullscreen.js').body
  end
end
