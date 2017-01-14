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
  local order = prototype.order
  local data = loadstring(order)()
  return data
end
