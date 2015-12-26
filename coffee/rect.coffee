class Rectangle

  constructor: (@position, @size, @style) ->

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
      height: @size.height * 0.75
    }

    leftRect = new Rectangle(leftRectPosition, leftRectSize, style)
    leftRect.draw(@ctx)

    rightRectPosition = {
      x: leftRect.position.x + Math.cos(leftRect.position.angle) * leftRect.size.width
      y: leftRect.position.y - Math.sin(leftRect.position.angle) * leftRect.size.width
      angle: @position.angle + @addAngle - Math.PI/2
    }
    rightRectSize = {
      width: @size.width * Math.sin(@addAngle)
      height: @size.height * 0.75
    }
    rightRect = new Rectangle(rightRectPosition, rightRectSize, style)
    rightRect.draw(@ctx)

    if @style.layer < 6
      setTimeout(leftRect.divide, 200)
      setTimeout(rightRect.divide, 200)