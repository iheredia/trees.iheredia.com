class Tree

  constructor: ->
    @canvas = new DrawingCanvas($('canvas'))
    min = Math.min(@canvas.el.height, @canvas.el.width)
    @baseWidth = min * 0.08
    @baseHeight = min * 0.08 * 16 / 9
    @growingTime = 200

    @branch_parameters = {
      up_growing: 50
      down_growing: 50
      depth: 7
      color: { h: 40, s: 0.9, v: 0.3 }
    }
    @leaves_parameters = {
      depth: 4
      squareness: 4
      color: { h: 115, s: 0.9, v: 0.3 }
      hue_variance: 10
    }

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

    @baseRect = new BranchRect(@, rectPosition, size)
    @draw()

  draw: ->
    @baseRect.draw(@canvas.ctx)
    @baseRect.divide()