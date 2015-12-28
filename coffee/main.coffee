$ ->
  tree = new Tree
  tree.generate()

  gui = new dat.GUI
  gui.add(tree, 'generate')