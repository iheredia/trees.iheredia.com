$ ->
  tree = new Tree
  tree.generate()

  gui = new dat.GUI
  height = gui.addFolder('height multiplier')
  height.add(tree, 'up_alpha')
  height.add(tree, 'up_beta')
  height.add(tree, 'down_alpha')
  height.add(tree, 'down_beta')
  general = gui.addFolder('general')
  general.add(tree, 'baseWidth', 0, tree.baseWidth*2)
  general.add(tree, 'baseHeight', 0, tree.baseWidth*2)
  general.add(tree, 'divideMeanTime', 0, 1000)
  general.add(tree, 'generate')
  general.open()
