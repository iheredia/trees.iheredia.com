$ ->
  tree = new Tree
  tree.generate()

  gui = new dat.GUI

  branches = gui.addFolder('branches')
  branches.add(tree, 'up_growing', 0, 100)
  branches.add(tree, 'down_growing', 0, 100)
  branches.add(tree, 'branch_depth', 1, 10).step(1)

  leaves = gui.addFolder('leaves')
  leaves.add(tree, 'squareness', 1, 10).step(1)
  leaves.add(tree, 'leaves_depth', 0, 10).step(1)

  general = gui.addFolder('general')
  general.add(tree, 'baseWidth', 0, tree.baseWidth*2)
  general.add(tree, 'baseHeight', 0, tree.baseWidth*2)
  general.add(tree, 'growingTime', 0, 1000)
  general.add(tree, 'generate')
  general.open()
