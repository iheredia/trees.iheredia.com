class DrawingCanvas

  constructor: (@$el) ->
    @el = @$el[0]
    $(window).resize(@setSizes)
    @setSizes()
    @ctx = @el.getContext('2d')

  setSizes: =>
    @el.width = @$el.width() if @el.width != @$el.width()
    @el.height = @$el.height() if @el.height != @$el.height()

  clear: ->
    @ctx.clearRect(0, 0, @el.width, @el.height)