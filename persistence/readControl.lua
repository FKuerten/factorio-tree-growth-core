function getTreeData(treeName)
  local textName = 'tree-growth-core-' .. treeName
  local textPrototype = game.entity_prototypes[textName]  
  if not textPrototype then return nil end
  local order = textPrototype.order
  if not order then return nil end
  local dataFunc = loadstring(order)
  if not dataFunc then return nil end
  --assert(dataFunc, "no data for " .. treeName .. " order=" .. order)
  local data = dataFunc()
  return data
end