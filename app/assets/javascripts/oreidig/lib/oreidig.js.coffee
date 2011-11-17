Oreidig = {}
window.Oreidig = Oreidig
$.mobile.hashListeningEnabled = false

$ ->
  app = new Oreidig.FrontPageController()
  app.renderLayout()
