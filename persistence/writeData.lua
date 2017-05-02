tree_growth = tree_growth or {}
tree_growth.core = tree_growth.core or {}

tree_growth.core.persist = function(treeName, treeData)
  assert(treeName, "need a name to persist")
  data.raw.tree[treeName].order = serpent.dump(treeData)
end