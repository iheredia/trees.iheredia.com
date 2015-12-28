$ ->
  tree = new Tree
  tree.generate()

  gui = new dat.GUI
  height = gui.addFolder('style')
  height.add(tree, 'up_growing', 0, 100)
  height.add(tree, 'down_growing', 0, 100)
  general = gui.addFolder('general')
  general.add(tree, 'baseWidth', 0, tree.baseWidth*2)
  general.add(tree, 'baseHeight', 0, tree.baseWidth*2)
  general.add(tree, 'divideMeanTime', 0, 1000)
  general.add(tree, 'generate')
  general.open()
