require "library/constants"

local pickRandomTree = function(nextTrees)
  local sum = 0
  local lastEntry
  for _, entry in ipairs(nextTrees) do
    sum = sum + entry.probability
    lastEntry = entry
  end
  local r = math.random() * sum
  local offset = 0
  for _, entry in ipairs(nextTrees) do
    offset = offset + entry.probability
    if r < offset then
      return entry
    end
  end
  -- should not happen.
  return lastEntry
end

remotes.getTreeData = function(treeName)
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
