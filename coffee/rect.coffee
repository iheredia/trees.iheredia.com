class Rectangle

  constructor: (@position, @size) ->
    @layer = 1

  brownHue: 40
  greenHue: 115
  saturation: 90

  draw: (@ctx) ->
    if @layer < 5
      hue = @brownHue
    else
      hue = @greenHue
    hue += Math.random() *20 - 10
    brightness = Math.random() * 20 + 25
    @ctx.fillStyle = "hsl(#{hue}, #{@saturation}%, #{brightness}%)"

    @ctx.translate(@position.x, @position.y)
    @ctx.rotate(-@position.angle)

    @ctx.fillRect(0, 0, @size.width, -@size.height)

    @ctx.rotate(@position.angle)
    @ctx.translate(-@position.x, -@position.y)


  addAngle: Math.PI/4

  isGoingDown: ->
    Math.cos(@position.angle) < 0

  divide: ->

    leftRect = new Rectangle({
      x: @position.x + Math.cos(Math.PI/2 + @position.angle) * @size.height
      y: @position.y - Math.sin(Math.PI/2 + @position.angle) * @size.height
      angle: @position.angle + @addAngle
    }, {
      width: @size.width * Math.cos(@addAngle)
      height: if Math.cos(@position.angle + @addAngle) < 0 then @size.height * 0.6 else @size.height * 0.75
    })
    leftRect.draw(@ctx)

    rightRect = new Rectangle({
      x: leftRect.position.x + Math.cos(leftRect.position.angle) * leftRect.size.width
      y: leftRect.position.y - Math.sin(leftRect.position.angle) * leftRect.size.width
      angle: @position.angle + @addAngle - Math.PI/2
    }, {
      width: @size.width * Math.sin(@addAngle)
      height: if Math.cos(@position.angle + @addAngle) < 0 then @size.height * 0.6 else @size.height * 0.75
    })
    rightRect.draw(@ctx)