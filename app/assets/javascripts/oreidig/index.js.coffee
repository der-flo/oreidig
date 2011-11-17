# Don't require JQuery -> CDN
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route

#= require_tree ./lib
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

# Setup Routes after app is loaded
Spine.Route.setup()
