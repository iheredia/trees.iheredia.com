class Rectangle

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


  addAngle: Math.PI/4

  divide: =>
    return if (@currentTree != @tree._currentTree or @depth >= @tree.branch_parameters.depth + @tree.leaves_parameters.depth)
    for rect in @childrenRect()
      rect.draw(@ctx)
      setTimeout(rect.divide, jStat.exponential.sample(1/@tree.general_parameters.growing_time))

  childrenRect: ->
    leftRect = @leftRect()
    rightRect = @rightRect(leftRect)
    [leftRect, rightRect]

  isGoingDown: (angle) ->
    Math.cos(angle) < 0

  leftRect: ->
    leftRectPosition = {
      x: @position.x + Math.cos(Math.PI/2 + @position.angle) * @size.height
      y: @position.y - Math.sin(Math.PI/2 + @position.angle) * @size.height
      angle: @position.angle + @addAngle
    }
    leftRectSize = {
      width: @size.width * Math.cos(@addAngle)
      height: @childHeight() * @heightMultiplier(leftRectPosition)
    }
    if @depth >= @tree.branch_parameters.depth
      new LeaveRect(@tree, leftRectPosition, leftRectSize, @depth+1)
    else
      new BranchRect(@tree, leftRectPosition, leftRectSize, @depth+1)

  rightRect: (leftRect)->
    rightRectPosition = {
      x: leftRect.position.x + Math.cos(leftRect.position.angle) * leftRect.size.width
      y: leftRect.position.y - Math.sin(leftRect.position.angle) * leftRect.size.width
      angle: @position.angle + @addAngle - Math.PI/2
    }
    rightRectSize = {
      width: @size.width * Math.sin(@addAngle)
      height: @childHeight() * @heightMultiplier(rightRectPosition)
    }
    if @depth >= @tree.branch_parameters.depth
      new LeaveRect(@tree, rightRectPosition, rightRectSize, @depth+1)
    else
      new BranchRect(@tree, rightRectPosition, rightRectSize, @depth+1)

  setColors: (rect_type) ->
    @hue = jStat.normal.sample(@tree[rect_type].color.h, @tree[rect_type].hue_variance)

    saturation_beta_parameter = (1-@tree[rect_type].color.s)/@tree[rect_type].color.s
    saturation_inverse_variance = 51 - @tree[rect_type].saturation_variance
    @saturation = jStat.beta.sample(saturation_inverse_variance, saturation_inverse_variance*saturation_beta_parameter)

    value_beta_parameter = (1-@tree[rect_type].color.v)/@tree[rect_type].color.v
    value_inverse_variance = 51 - @tree[rect_type].value_variance
    @value = jStat.beta.sample(value_inverse_variance, value_inverse_variance*value_beta_parameter)

class BranchRect extends Rectangle

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

class LeaveRect extends Rectangle

  heightMultiplier: (position) ->
    1 + jStat.beta.sample(10.1 - @tree.leaves_parameters.squareness, 10)

  childHeight: ->
    @size.width

  setColors: ->
    super('leaves_parameters')
