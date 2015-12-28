$ ->
  tree = new Tree
  tree.generate()

  gui = new dat.GUI

  branches = gui.addFolder('branches')
  branches.add(tree.branch_parameters, 'up_growing', 0, 100)
  branches.add(tree.branch_parameters, 'down_growing', 0, 100)
  branches.add(tree.branch_parameters, 'depth', 1, 10).step(1)
  branches.addColor(tree.branch_parameters, 'color')

  leaves = gui.addFolder('leaves')
  leaves.add(tree.leaves_parameters, 'squareness', 0, 10).step(0.1)
  leaves.add(tree.leaves_parameters, 'depth', 0, 10).step(1)
  leaves.addColor(tree.leaves_parameters, 'color')
  leaves.add(tree.leaves_parameters, 'hue_variance', 0, 50)

  general = gui.addFolder('general')
  general.add(tree, 'baseWidth', 0, tree.baseWidth*2)
  general.add(tree, 'baseHeight', 0, tree.baseWidth*2)
  general.add(tree, 'growingTime', 0, 1000)
  general.add(tree, 'generate')
  general.open()
