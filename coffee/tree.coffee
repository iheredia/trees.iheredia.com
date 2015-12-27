class Tree

  constructor: ->
    @canvas = new DrawingCanvas($('canvas'))
    @reGenerate()

  reGenerate: ->
    min = Math.min(@canvas.el.height, @canvas.el.width)
    size = {
      width: min * 0.08
      height: min * 0.08 * 16 / 9
    }
    rectPosition = {
      x: @canvas.el.width/2 - size.width/2
      y: @canvas.el.height*0.9
      angle: 0
    }
    style = {
      layer: 0
    }
    @baseRect = new Rectangle(rectPosition, size, style)

  draw: ->
    @baseRect.draw(@canvas.ctx)
    @baseRect.divide()