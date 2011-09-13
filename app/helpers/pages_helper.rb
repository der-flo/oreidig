module PagesHelper
  
  def popup_bookmarklet_js
    # http://blog.phusion.nl/2011/08/14/rendering-rails-3-1-assets-to-string/
    # TODO Flo: See comment in blog post - compression is not applied?
    str = Oreidig::Application.assets.find_asset('bookmarklets/popup.js').body
    Uglifier.compile(str)
  end
  def fullscreen_bookmarklet_js
    str =
      Oreidig::Application.assets.find_asset('bookmarklets/fullscreen.js').body
    Uglifier.compile(str)
  end
end
