function getTreeData(treeName)
  local prototype = game.entity_prototypes[treeName]
  if not prototype then return nil end
  local order = prototype.order
  if not order then return nil end
  local dataFunc = loadstring(order)
  if not dataFunc then return nil end
  --assert(dataFunc, "no data for " .. treeName .. " order=" .. order)
  local data = dataFunc()
  return data
end