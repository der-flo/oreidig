module PagesHelper
  
  def popup_bookmarklet_js
    # http://blog.phusion.nl/2011/08/14/rendering-rails-3-1-assets-to-string/
    str = Oreidig::Application.assets['bookmarklets/popup.js'].body
    Uglifier.compile(str)
  end
  def fullscreen_bookmarklet_js
    str =
      Oreidig::Application.assets['bookmarklets/fullscreen.js'].body
    Uglifier.compile(str)
  end
end
