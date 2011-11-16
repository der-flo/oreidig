#= require json2
# Don't require JQuery -> CDN
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class Oreidig extends Spine.Controller
  @view: (name) ->
    JST["oreidig/views/#{name}"]

  constructor: ->
    super
    
    # Initialize controllers:
    #  @append(@items = new Oreidig.Items)
    #  ...
    
    Spine.Route.setup()    

window.Oreidig = Oreidig
