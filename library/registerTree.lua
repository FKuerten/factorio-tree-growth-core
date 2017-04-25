tree_growth = tree_growth or {}
tree_growth.core = tree_growth.core or {}
require "library/constants"

local treeData = {}
local function persist(treeName)
  assert(treeName, "need a name to persist")
  data.raw.tree[treeName].order = serpent.dump(treeData[treeName])
end

local function resolveEntity(label, object)
  assert(object, label .. " missing")
  local name, entity
  if type(object) == "string" then
    name = object
  elseif type(object) == "table" then
    assert (object.name, label .. " is not a valid entity")
    name = object.name
  end
  entity = data.raw.tree[name]
  assert (entity, label .. " entity ".. name .. " is not registered")
  return name, entity
end

local function getNode(...)
  local t = treeData
  local function f(t, k, ...)
    if k then
      if not t[k] then t[k] = {} end
      return f(t[k], ...)
    else
      return t
    end
  end
  return f(t, ...)
end

--- Registers a single tree as relevant.
-- If more than one upgrade exist for a tree a random tree will be chosen. The probabilities will be used as weights.
--
-- @param base the name of the base tree or the entity
-- @param upgrade the name of upgrade tree or the entity
-- @param probability the probability that this upgrade will be chosen
-- @param minDelay the minimum time until the upgrade will be applied if its chosen
-- @param minDelay the maximum time until the upgrade will be applied if its chosen
tree_growth.core.registerUpgrade = function(base, upgrade, probability, minDelay, maxDelay)
  local baseName, baseEntity = resolveEntity("base", base)
  local upgradeName, upgradeEntity = resolveEntity("upgrade", upgrade)
  assert(probability, "probability missing")
  assert(type(probability) == "number" and probability > 0, "probability is not a positive number")
  assert(minDelay, "delay missing")
  if not maxDelay then
    assert(type(minDelay) == "number" and minDelay > 0, "delay is not a positive number")
    maxDelay = minDelay
  else
    assert(type(minDelay) == "number" and minDelay > 0, "minDelay is not a positive number")
    assert(type(maxDelay) == "number" and maxDelay > 0, "minDelay is not a positive number")
  end

  table.insert(getNode(baseName, "upgrades"), {
    name = upgradeName,
    probability = probability,
    minDelay = minDelay,
    maxDelay = maxDelay,
  })
  persist(baseName)

  table.insert(getNode(upgradeName, "previous"), baseName)
  persist(upgradeName, upgradeData)

  if next(getNode(baseName, "previous")) then
    baseEntity.subgroup = tree_growth.core.groups.intermediate
  else
    baseEntity.subgroup = tree_growth.core.groups.sapling
  end

  if next(getNode(upgradeName, "upgrades")) then
    upgradeEntity.subgroup = tree_growth.core.groups.intermediate
  else
    upgradeEntity.subgroup = tree_growth.core.groups.mature
  end
end

tree_growth.core.registerOffspring = function(tree, sapling)
  local treeName, treeEntity = resolveEntity("tree", tree)
  local saplingName, saplingName = resolveEntity("sapling", sapling)

  table.insert(getNode(treeName, "saplings"), saplingName)
  persist(treeName)
  table.insert(getNode(saplingName, "parents"), treeName)
  persist(saplingName)
end
