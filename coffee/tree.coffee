class Tree

  constructor: ->
    @canvas = new DrawingCanvas($('canvas'))
    min = Math.min(@canvas.el.height, @canvas.el.width)
    @baseWidth = min * 0.08
    @baseHeight = min * 0.08 * 16 / 9
    @growingTime = 200

    @up_growing = 50
    @down_growing = 50
    @branch_depth = 7
    @leaves_depth = 4
    @squareness = 4

  generate: =>
    @_calculateGrowing()
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

  _calculateGrowing: ->
    @up_alpha = @up_growing
    @up_beta = 25
    @down_alpha = @down_growing
    @down_beta = 25
