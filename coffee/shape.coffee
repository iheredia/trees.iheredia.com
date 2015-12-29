class Shape

  constructor: (@tree, @position, @size, @depth = 1) ->
    @currentTree = @tree._currentTree

  draw: (@ctx) ->
    {
      rects: @drawRects
      ellipsis: @drawEllipsis
    }[@tree.general_parameters.shape]()

  drawRects: =>
    @setColors()
    @ctx.fillStyle = "hsl(#{@hue}, #{@saturation * 100}%, #{@value * 100}%)"

    @ctx.translate(@position.x, @position.y)
    @ctx.rotate(-@position.angle)

    @ctx.fillRect(0, 0, @size.width, -@size.height)

    @ctx.rotate(@position.angle)
    @ctx.translate(-@position.x, -@position.y)

  drawEllipsis: =>
    @setColors()
    @ctx.save()
    @ctx.fillStyle = "hsl(#{@hue}, #{@saturation * 100}%, #{@value * 100}%)"

    @ctx.translate(@position.x, @position.y)
    @ctx.rotate(-@position.angle)

    @ctx.scale(1, @size.height/@size.width)

    @ctx.beginPath()
    @ctx.arc(@size.width/2, -@size.width/2, @size.width/2, 0, 2 * Math.PI, false)

    @ctx.fill()
    @ctx.restore()

  limitReached: ->
    @currentTree != @tree._currentTree or @depth >= @tree.branch_parameters.depth + @tree.leaves_parameters.depth

  divide: =>
    unless @limitReached()
      for shape in @childrenShapes()
        shape.draw(@ctx)
        timeout = jStat.exponential.sample(1 / @tree.general_parameters.growing_time)
        setTimeout(shape.divide, timeout)

  childrenShapes: ->
    if @depth >= @tree.branch_parameters.depth
      ShapeClass = LeaveShape
    else
      ShapeClass = BranchShape
    parameters = @childParameters()
    leftShape = new ShapeClass(@tree, parameters.leftPosition, parameters.leftSize, @depth+1)
    rightShape = new ShapeClass(@tree, parameters.rightPosition, parameters.rightSize, @depth+1)
    [leftShape, rightShape]

  childSize: (side) ->
    trig = if side == 'left' then Math.cos else Math.sin
    {width: @size.width * trig(@addAngle), height: @childHeight()}

  childParameters: ->
    angle_mean = @tree.growth_parameters.split_direction
    angle_variance = @tree.growth_parameters.split_variance
    @addAngle = beta_sample_for(angle_mean / 180, angle_variance / 10 * 0.25) * Math.PI/2

    leftSize = @childSize('left')
    rightSize = @childSize('right')
    leftPosition = {
      x: @position.x + Math.cos(Math.PI / 2 + @position.angle) * @size.height
      y: @position.y - Math.sin(Math.PI / 2 + @position.angle) * @size.height
      angle: @position.angle + @addAngle
    }
    rightPosition = {
      x: leftPosition.x + Math.cos(leftPosition.angle) * leftSize.width
      y: leftPosition.y - Math.sin(leftPosition.angle) * leftSize.width
      angle: @position.angle + @addAngle - Math.PI / 2
    }
    {
      leftPosition: leftPosition
      rightPosition: rightPosition
      leftSize: leftSize
      rightSize: rightSize
    }

  setColors: (shape_type) ->
    @hue = jStat.normal.sample(@tree[shape_type].color.h, @tree[shape_type].hue_variance)

    saturation_beta_parameter = (1 - @tree[shape_type].color.s) / @tree[shape_type].color.s
    saturation_inverse_variance = 51 - @tree[shape_type].saturation_variance
    @saturation = jStat.beta.sample(saturation_inverse_variance,
      saturation_inverse_variance * saturation_beta_parameter)

    value_beta_parameter = (1 - @tree[shape_type].color.v) / @tree[shape_type].color.v
    value_inverse_variance = 51 - @tree[shape_type].value_variance
    @value = jStat.beta.sample(value_inverse_variance, value_inverse_variance * value_beta_parameter)

  isGoingDown: (angle) ->
    Math.cos(angle) < 0

class BranchShape extends Shape

  beta: 25
  constructor: (@tree, @position, @size, @depth = 1) ->
    super(@tree, @position, @size, @depth)
    @size.height *= @heightMultiplier() unless @depth == 0

  heightMultiplier: ->
    if @isGoingDown(@position.angle)
      jStat.beta.sample(@tree.branch_parameters.down_growing, @beta)
    else
      jStat.beta.sample(@tree.branch_parameters.up_growing, @beta)

  childHeight: ->
    if @depth < @tree.branch_parameters.depth
      @size.height
    else
      @size.width

  setColors: ->
    super('branch_parameters')

class LeaveShape extends Shape

  constructor: (@tree, @position, @size, @depth = 1) ->
    super(@tree, @position, @size, @depth)
    @size.height *= @heightMultiplier()

  heightMultiplier: ->
    1 + 2 * jStat.beta.sample(100.1 - @tree.leaves_parameters.squareness, 100)

  childHeight: ->
    @size.width

  setColors: ->
    super('leaves_parameters')
