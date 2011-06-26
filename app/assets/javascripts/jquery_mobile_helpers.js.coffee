# collapse page navs after use
$( () -> 
  $('body').delegate('.content-secondary .ui-collapsible-content', 
    'vclick', () ->
    $(this).trigger("collapse")
  )
)

default_transition = () -> {
  winwidth = $( window ).width()
  trans ="slide"
  if( winwidth >= 1000 ){
    trans = "none"
  }
  else if( winwidth >= 650 ){
    trans = "fade"
  }
  $.mobile.defaultPageTransition = trans
}

# set default documentation
$( document ).bind( "mobileinit", setDefaultTransition )
$( ->
  $( window ).bind( "throttledresize", setDefaultTransition )
)

