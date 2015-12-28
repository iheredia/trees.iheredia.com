$ ->
  tree = new Tree
  tree.generate()

  gui = new dat.GUI
  gui.add(tree, 'baseWidth', 0, tree.baseWidth*2)
  gui.add(tree, 'baseHeight', 0, tree.baseWidth*2)
  gui.add(tree, 'generate')
