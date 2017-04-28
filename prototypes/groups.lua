require "library/constants"

data:extend({
  {
    type = "item-group",
    name = "tree-growth",
    order = "e",
    inventory_order = "e",
    icon = "__base__/graphics/icons/tree-05.png",
    icon_size = 32,
  },
  {
    type = "item-subgroup",
    name = tree_growth.core.groups.seed,
    group = "tree-growth",
    order = "a",
  },
  {
    type = "item-subgroup",
    name = tree_growth.core.groups.sapling,
    group = "tree-growth",
    order = "b",
  },
  {
    type = "item-subgroup",
    name = tree_growth.core.groups.intermediate,
    group = "tree-growth",
    order = "c",
  },
  {
    type = "item-subgroup",
    name = tree_growth.core.groups.mature,
    group = "tree-growth",
    order = "d",
  },
})
