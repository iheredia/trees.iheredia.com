class Rectangle

  constructor: (@tree, @position, @size, @style) ->
    @currentTree = @tree._currentTree

  brownHue: 40
  greenHue: 115
  saturation: 90

  draw: (@ctx) ->
    hue = (@style.hue || @brownHue) + Math.random() *20 - 10
    brightness = Math.random() * 20 + 25
    @ctx.fillStyle = "hsl(#{hue}, #{@saturation}%, #{brightness}%)"

    @ctx.translate(@position.x, @position.y)
    @ctx.rotate(-@position.angle)

    @ctx.fillRect(0, 0, @size.width, -@size.height)

    @ctx.rotate(@position.angle)
    @ctx.translate(-@position.x, -@position.y)


  addAngle: Math.PI/4

  divide: =>
    return unless @currentTree == @tree._currentTree
    for rect in @childrenRect()
      rect.draw(@ctx)
      if @style.layer < 10
        setTimeout(rect.divide, jStat.exponential.sample(1/@tree.divideMeanTime))

  childrenRect: ->
    leftRect = @leftRect()
    rightRect = @rightRect(leftRect)
    [leftRect, rightRect]

  isGoingDown: (angle) ->
    Math.cos(angle) < 0

  heightMultiplier: (position) ->
    if @isGoingDown(position.angle)
      jStat.beta.sample(@tree.down_alpha, @tree.down_beta)
    else
      jStat.beta.sample(@tree.up_alpha, @tree.up_beta)

  leftRect: ->
    style = {
      layer: @style.layer + 1
      hue: if @style.layer < 5 then @brownHue else @greenHue
    }
    leftRectPosition = {
      x: @position.x + Math.cos(Math.PI/2 + @position.angle) * @size.height
      y: @position.y - Math.sin(Math.PI/2 + @position.angle) * @size.height
      angle: @position.angle + @addAngle
    }
    leftRectSize = {
      width: @size.width * Math.cos(@addAngle)
      height: @size.height * @heightMultiplier(leftRectPosition)
    }

    new Rectangle(@tree, leftRectPosition, leftRectSize, style)

  rightRect: (leftRect)->
    style = {
      layer: @style.layer + 1
      hue: if @style.layer < 5 then @brownHue else @greenHue
    }
    rightRectPosition = {
      x: leftRect.position.x + Math.cos(leftRect.position.angle) * leftRect.size.width
      y: leftRect.position.y - Math.sin(leftRect.position.angle) * leftRect.size.width
      angle: @position.angle + @addAngle - Math.PI/2
    }
    rightRectSize = {
      width: @size.width * Math.sin(@addAngle)
      height: @size.height * @heightMultiplier(rightRectPosition)
    }
    new Rectangle(@tree, rightRectPosition, rightRectSize, style)