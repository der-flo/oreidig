# class Oreidig.ViewBuilder
# Proof of concept (Sven)
# Something like an easy view-builder
# At least it functions
# @each is another good idea
#

class ViewBuilder
  @tag: (tag, attrs, closure) ->
    attrs_str = @attributes(attrs)
    opening_tag = [tag]
    opening_tag.push(attrs_str) if attrs_str?
    @_output = "<#{opening_tag.join(" ")}>"
    @closure(attrs, closure)
    @_output += "</#{tag}>"

  @attributes: (attrs) ->
    return if typeof(attrs) isnt "object"
    attrs_array = for key, value of attrs
      if typeof(value) == "object"
        line = for k, v of value
          "#{key}-#{k}=\"#{v}\""
        line.join(" ")
      else 
        line = "#{key}=\"#{value}\""
    attrs_array.join(" ")
    

  @closure: (attrs, closure) ->
    closure = attrs if typeof(attrs) isnt "object"
    if typeof(closure) is "function"
      @_output += closure.call(@)
    else if typeof(closure) is "string"
      @_output += closure


  @concat: ->
    concat = ""
    concat += blck for blck in arguments
    concat
    

class BaseView extends ViewBuilder
  @render: ->
    @template.apply(@, arguments)

class FunkyView extends BaseView
  @template: (funk) ->
    @tag "ul", ->
      @tag "li", ->
        @concat @tag("item", {class: "home", data: {role: "page"}}, "honk"),
                @tag("item", funk),
                @tag("honk", ->
                   @tag "super", "buddy")


console.log FunkyView.render("yoyoyo")
