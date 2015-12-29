class Shape

  addAngle: Math.PI/4

  constructor: (@tree, @position, @size, @depth=1) ->
    @currentTree = @tree._currentTree

  draw: (@ctx) ->
    @setColors()
    @ctx.fillStyle = "hsl(#{@hue}, #{@saturation*100}%, #{@value*100}%)"

    @ctx.translate(@position.x, @position.y)
    @ctx.rotate(-@position.angle)

    @ctx.fillRect(0, 0, @size.width, -@size.height)

    @ctx.rotate(@position.angle)
    @ctx.translate(-@position.x, -@position.y)

  limitReached: ->
    @currentTree != @tree._currentTree or @depth >= @tree.branch_parameters.depth + @tree.leaves_parameters.depth

  divide: =>
    unless @limitReached()
      for shape in @childrenShapes()
        shape.draw(@ctx)
        timeout = jStat.exponential.sample(1/@tree.general_parameters.growing_time)
        setTimeout(shape.divide, timeout)

  childrenShapes: ->
    leftShape = @leftShape()
    rightShape = @rightShape(leftShape)
    [leftShape, rightShape]

  isGoingDown: (angle) ->
    Math.cos(angle) < 0

  leftShape: ->
    leftShapePosition = {
      x: @position.x + Math.cos(Math.PI/2 + @position.angle) * @size.height
      y: @position.y - Math.sin(Math.PI/2 + @position.angle) * @size.height
      angle: @position.angle + @addAngle
    }
    leftShapeSize = {
      width: @size.width * Math.cos(@addAngle)
      height: @childHeight() * @heightMultiplier(leftShapePosition)
    }
    if @depth >= @tree.branch_parameters.depth
      new LeaveShape(@tree, leftShapePosition, leftShapeSize, @depth+1)
    else
      new BranchShape(@tree, leftShapePosition, leftShapeSize, @depth+1)

  rightShape: (leftShape)->
    rightShapePosition = {
      x: leftShape.position.x + Math.cos(leftShape.position.angle) * leftShape.size.width
      y: leftShape.position.y - Math.sin(leftShape.position.angle) * leftShape.size.width
      angle: @position.angle + @addAngle - Math.PI/2
    }
    rightShapeSize = {
      width: @size.width * Math.sin(@addAngle)
      height: @childHeight() * @heightMultiplier(rightShapePosition)
    }
    if @depth >= @tree.branch_parameters.depth
      new LeaveShape(@tree, rightShapePosition, rightShapeSize, @depth+1)
    else
      new BranchShape(@tree, rightShapePosition, rightShapeSize, @depth+1)

  setColors: (shape_type) ->
    @hue = jStat.normal.sample(@tree[shape_type].color.h, @tree[shape_type].hue_variance)

    saturation_beta_parameter = (1-@tree[shape_type].color.s)/@tree[shape_type].color.s
    saturation_inverse_variance = 51 - @tree[shape_type].saturation_variance
    @saturation = jStat.beta.sample(saturation_inverse_variance, saturation_inverse_variance*saturation_beta_parameter)

    value_beta_parameter = (1-@tree[shape_type].color.v)/@tree[shape_type].color.v
    value_inverse_variance = 51 - @tree[shape_type].value_variance
    @value = jStat.beta.sample(value_inverse_variance, value_inverse_variance*value_beta_parameter)

class BranchShape extends Shape

  beta: 25
  heightMultiplier: (position) ->
    if @isGoingDown(position.angle)
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

  heightMultiplier: (position) ->
    1 + 2*jStat.beta.sample(100.1 - @tree.leaves_parameters.squareness, 100)

  childHeight: ->
    @size.width

  setColors: ->
    super('leaves_parameters')
