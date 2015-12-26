class Tree

  constructor: ->
    @canvas = new DrawingCanvas($('canvas'))
    @reGenerate()

  reGenerate: ->
    rectPosition = {
      x: @canvas.el.width * 0.45
      y: @canvas.el.height * 0.95
      angle: 0
    }
    size = {
      width: @canvas.el.width * 0.1
      height: @canvas.el.height * 0.2
    }
    rect = new Rectangle(rectPosition, size)

    @currentLayer = []
    @currentLayer.push(rect)

  draw: ->
    for i in [0.. Math.min(500, @currentLayer.length)]
      n = Math.round(Math.random() * @currentLayer.length/2)
      rect = @currentLayer[n]
      rect.draw(@canvas.ctx)
