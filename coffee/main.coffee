$ ->
  tree = new Tree
  tree.generate()

  gui = new dat.GUI

  branches = gui.addFolder('branches')
  branches.add(tree.branch_parameters, 'up_growing', 0, 100)
  branches.add(tree.branch_parameters, 'down_growing', 0, 100)
  branches.add(tree.branch_parameters, 'depth', 1, 10).step(1)
  branches.addColor(tree.branch_parameters, 'color')
  branches.add(tree.branch_parameters, 'hue_variance', 0, 20)
  branches.add(tree.branch_parameters, 'saturation_variance', 0, 50)
  branches.add(tree.branch_parameters, 'value_variance', 0, 50)

  leaves = gui.addFolder('leaves')
  leaves.add(tree.leaves_parameters, 'squareness', 0, 10).step(0.1)
  leaves.add(tree.leaves_parameters, 'depth', 0, 10).step(1)
  leaves.addColor(tree.leaves_parameters, 'color')
  leaves.add(tree.leaves_parameters, 'hue_variance', 0, 50)
  leaves.add(tree.leaves_parameters, 'saturation_variance', 0, 50)
  leaves.add(tree.leaves_parameters, 'value_variance', 0, 50)

  general = gui.addFolder('trunk')
  general.add(tree.trunk_parameters, 'width', 0, tree.trunk_parameters.width*2)
  general.add(tree.trunk_parameters, 'height', 0, tree.trunk_parameters.width*2)

  gui.add(tree.general_parameters, 'growing_time', 0, 1000)
  gui.add(tree, 'generate')
