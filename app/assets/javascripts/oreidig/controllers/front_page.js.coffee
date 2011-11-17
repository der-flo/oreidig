class Oreidig.FrontPageController extends Spine.Controller
  constructor: ->
    @routes
      "": (params) ->
        console.log("/", params)
      "/": (params) ->
        console.log("/", params)

