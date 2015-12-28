class Rectangle

  constructor: (@tree, @position, @size, @depth=1) ->
    @currentTree = @tree._currentTree

  draw: (@ctx) ->
    hue = @hue + Math.random() *20 - 10
    brightness = Math.random() * 20 + 25
    @ctx.fillStyle = "hsl(#{hue}, #{90}%, #{brightness}%)"

    @ctx.translate(@position.x, @position.y)
    @ctx.rotate(-@position.angle)

    @ctx.fillRect(0, 0, @size.width, -@size.height)

    @ctx.rotate(@position.angle)
    @ctx.translate(-@position.x, -@position.y)


  addAngle: Math.PI/4

  divide: =>
    return if (@currentTree != @tree._currentTree or @depth >= @tree.branch_depth + @tree.leaves_depth)
    for rect in @childrenRect()
      rect.draw(@ctx)
      setTimeout(rect.divide, jStat.exponential.sample(1/@tree.growingTime))

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
    if @depth >= @tree.branch_depth
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
    if @depth >= @tree.branch_depth
      new LeaveRect(@tree, rightRectPosition, rightRectSize, @depth+1)
    else
      new BranchRect(@tree, rightRectPosition, rightRectSize, @depth+1)

class BranchRect extends Rectangle
  hue: 40
  beta: 25
  heightMultiplier: (position) ->
    if @isGoingDown(position.angle)
      jStat.beta.sample(@tree.down_growing, @beta)
    else
      jStat.beta.sample(@tree.up_growing, @beta)

  childHeight: ->
    if @depth < @tree.branch_depth
      @size.height
    else
      @size.width

class LeaveRect extends Rectangle
  hue: 115

  heightMultiplier: (position) ->
    1 + jStat.beta.sample(10.1 - @tree.squareness, 10)

  childHeight: ->
    @size.width