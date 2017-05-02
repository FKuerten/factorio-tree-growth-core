tree_growth = tree_growth or {}
tree_growth.core = tree_growth.core or {}

tree_growth.core.persist = function(treeName, treeData)
  assert(treeName, "need a name to persist")
  local textName = 'tree-growth-core-' .. treeName
  local serializedData = serpent.dump(treeData)
  
  -- actually store it
  if data.raw['flying-text'][textName] then
    data.raw['flying-text'][textName].order = serializedData
  else
    data:extend({{
      type = "flying-text",
      name = textName,
      time_to_live = 0,
      speed = 1,
      order = serializedData
    }})
  end
end