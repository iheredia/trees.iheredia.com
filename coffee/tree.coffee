class Tree

  constructor: ->
    @canvas = new DrawingCanvas($('canvas'))
    min = Math.min(@canvas.el.height, @canvas.el.width)
    @baseWidth = min * 0.08
    @baseHeight = min * 0.08 * 16 / 9
    @divideMeanTime = 200

    @up_alpha = 8
    @up_beta = 4
    @down_alpha = 6
    @down_beta = 4

  generate: =>
    @_currentTree = Math.random()
    @canvas.clear()
    size = {
      width: @baseWidth
      height: @baseHeight
    }

    rectPosition = {
      x: @canvas.el.width/2 - size.width/2
      y: @canvas.el.height*0.9
      angle: 0
    }

    style = {
      layer: 0
    }

    @baseRect = new Rectangle(@, rectPosition, size, style)
    @draw()

  draw: ->
    @baseRect.draw(@canvas.ctx)
    @baseRect.divide()