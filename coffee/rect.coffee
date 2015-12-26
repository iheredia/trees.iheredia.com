class Rectangle

  constructor: (@position, @size) ->
    @layer = 1

  brownHue: 40
  greenHue: 115
  saturation: 90

  draw: (ctx) ->
    if @layer < 5
      hue = @brownHue
    else
      hue = @greenHue
    hue += Math.random() *20 - 10
    brightness = Math.random() * 20 + 25
    ctx.fillStyle = "hsl(#{hue}, #{@saturation}%, #{brightness}%)"
    ctx.translate(@position.x, @position.y)
    ctx.rotate(@position.angle)
    ctx.fillRect(0, 0, @size.width, @size.height)
    ctx.rotate(-@position.angle)
    ctx.translate(-@position.x, -@position.y)


  baseAngle: Math.PI/4
