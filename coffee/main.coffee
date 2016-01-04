$ ->
  tree = new Tree
  tree.generate()

  gui = new dat.GUI(
    load: {
      "preset": "tree",
      "closed": false,
      "remembered": {
        "tree": {"0":{"growing_time":200,"background":"#ffffff","clean_canvas":true,"shape":"rects"},"1":{"up_growing":150,"down_growing":20,"depth":7,"color":{"h":40,"s":0.9,"v":0.3},"hue_variance":5,"saturation_variance":30,"value_variance":10},"2":{"depth":5,"squareness":50,"color":{"h":115,"s":0.9,"v":0.3},"hue_variance":10,"saturation_variance":10,"value_variance":10},"3":{"width":60,"height":110},"4":{"split_direction":90,"split_variance":0.5}},
        "ellipsis": {"0":{"growing_time":200,"background":"#6a9aa4","shape":"ellipsis","clean_canvas":true},"1":{"up_growing":200,"down_growing":103.6704866667622,"depth":6,"color":{"h":201.1764705882353,"s":0.9,"v":0.3},"hue_variance":5.514387588657563,"saturation_variance":27.020499184422057,"value_variance":28.123376702153575},"2":{"squareness":16.543162765972692,"depth":5,"color":{"h":282.3529411764706,"s":0.9,"v":0.3},"hue_variance":10,"saturation_variance":10,"value_variance":10},"3":{"width":50,"height":70},"4":{"split_direction":90,"split_variance":0.1519403365320457}}
      }
    }
  )

  gui.remember(tree.general_parameters)
  gui.remember(tree.branch_parameters)
  gui.remember(tree.leaves_parameters)
  gui.remember(tree.trunk_parameters)
  gui.remember(tree.growth_parameters)

  branches = gui.addFolder('branches')
  branches.add(tree.branch_parameters, 'up_growing', 0, 200)
  branches.add(tree.branch_parameters, 'down_growing', 0, 200)
  branches.add(tree.branch_parameters, 'depth', 1, 10).step(1)
  branches.addColor(tree.branch_parameters, 'color')
  branches.add(tree.branch_parameters, 'hue_variance', 0, 20)
  branches.add(tree.branch_parameters, 'saturation_variance', 0, 50)
  branches.add(tree.branch_parameters, 'value_variance', 0, 50)

  leaves = gui.addFolder('leaves')
  leaves.add(tree.leaves_parameters, 'squareness', 0, 100)
  leaves.add(tree.leaves_parameters, 'depth', 0, 10).step(1)
  leaves.addColor(tree.leaves_parameters, 'color')
  leaves.add(tree.leaves_parameters, 'hue_variance', 0, 50)
  leaves.add(tree.leaves_parameters, 'saturation_variance', 0, 50)
  leaves.add(tree.leaves_parameters, 'value_variance', 0, 50)

  general = gui.addFolder('trunk')
  general.add(tree.trunk_parameters, 'width', 0, tree.trunk_parameters.width * 4)
  general.add(tree.trunk_parameters, 'height', 0, tree.trunk_parameters.width * 4)
  general.add(tree.trunk_parameters, 'position_x', 0, 100)
  general.add(tree.trunk_parameters, 'position_y', 0, 100)

  growth = gui.addFolder('growth')
  growth.add(tree.growth_parameters, 'split_direction', 1, 180)
  growth.add(tree.growth_parameters, 'split_variance', 0.01, 1)

  gui.add(tree.general_parameters, 'growing_time', 0, 1000)
  gui.addColor(tree.general_parameters, 'background')
  gui.add(tree.general_parameters, 'shape', ['rects', 'ellipsis'])
  gui.add(tree.general_parameters, 'clean_canvas')
  gui.add(tree, 'generate')
