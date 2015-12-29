class Tree

  constructor: ->
    @canvas = new DrawingCanvas($('canvas'))

    @general_parameters = {
      growing_time: 200
      background: "#ffffff"
      clean_canvas: true
      shape: 'rects'
    }

    @trunk_parameters = {
      width: 60
      height: 110
    }

    @branch_parameters = {
      up_growing: 150
      down_growing: 20
      depth: 7
      color: { h: 40, s: 0.9, v: 0.3 }
      hue_variance: 5
      saturation_variance: 30
      value_variance: 10
    }

    @leaves_parameters = {
      depth: 5
      squareness: 50
      color: { h: 115, s: 0.9, v: 0.3 }
      hue_variance: 10
      saturation_variance: 10
      value_variance: 10
    }

    @growth_parameters = {
      split_direction: 90
      split_variance: 0.5
    }

  generate: =>
    @_currentTree = Math.random()
    @canvas.clear(@general_parameters.background) if @general_parameters.clean_canvas
    size = {
      width: @trunk_parameters.width
      height: @trunk_parameters.height
    }

    shapePosition = {
      x: @canvas.el.width/2 - size.width/2
      y: @canvas.el.height*0.7
      angle: 0
    }

    @baseShape = new BranchShape(@, shapePosition, size)
    @draw()

  draw: ->
    @baseShape.draw(@canvas.ctx)
    @baseShape.divide()
