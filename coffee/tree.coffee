class Tree

  constructor: ->
    @canvas = new DrawingCanvas($('canvas'))
    @reGenerate()

  reGenerate: ->
    size = {
      width: @canvas.el.width * 0.1
      height: @canvas.el.width * 0.1 * 16 / 9
    }
    rectPosition = {
      x: @canvas.el.width/2 - size.width/2
      y: @canvas.el.height
      angle: 0
    }
    @baseRect = new Rectangle(rectPosition, size)

  draw: ->
    @baseRect.draw(@canvas.ctx)
    @baseRect.divide()