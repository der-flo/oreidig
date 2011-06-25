module PagesHelper
  
  def popup_bookmarklet_js
    # TODO: Simplify stuff with the new asset pipeline?
    str = render template: 'pages/bookmarklets/popup.js.erb'
    # TODO: Other minification options?
    Uglifier.compile(str)
  end
  def fullscreen_bookmarklet_js
    # TODO: Simplify stuff with the new asset pipeline?
    str = render template: 'pages/bookmarklets/fullscreen.js.erb'
    # TODO: Other minification options?
    Uglifier.compile(str)
  end
end
