class Tree

  constructor: ->
    @canvas = new DrawingCanvas($('canvas'))

    @general_parameters = {
      growing_time: 200
      background: "#ffffff"
    }

    min = Math.min(@canvas.el.height, @canvas.el.width)
    @trunk_parameters = {
      width: min * 0.08
      height: min * 0.08 * 16 / 9
    }

    @branch_parameters = {
      up_growing: 50
      down_growing: 50
      depth: 7
      color: { h: 40, s: 0.9, v: 0.3 }
      hue_variance: 5
      saturation_variance: 30
      value_variance: 10
    }

    @leaves_parameters = {
      depth: 4
      squareness: 4
      color: { h: 115, s: 0.9, v: 0.3 }
      hue_variance: 10
      saturation_variance: 10
      value_variance: 10
    }

  generate: =>
    @_currentTree = Math.random()
    @canvas.clear(@general_parameters.background)
    size = {
      width: @trunk_parameters.width
      height: @trunk_parameters.height
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