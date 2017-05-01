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

local function resolveNumber(label, number)
  if type(number) ~= "number" then
    error(label .. " is not a number: " .. tostring(number))
  end
  return number
end

local function resolveProbability(label, number)
  resolveNumber(label, number)
  if number < 0 then
    error(label .. " is not a probability: " .. tostring(number))
  end
  return number
end

local function resolveTileFilter(label, tiles)
  if type(tiles) == 'nil' then
    return nil
  elseif type(tiles) ~= 'table' then
    error(label .. " is neither nil nor a table: " .. type(tiles))
  else
    local result = {}
    for k,v in pairs(tiles) do
      if type(k) ~= 'string' then
        error(label .. " key " .. tostring(k) .. " is not a string")
      end
      result[k] = v and true or false
    end
    return result
  end
end

local function resolveVariations(label, variations)
  if type(variations) == 'nil' then
    error(label .. " must not be nil")
  elseif (variations == "id") or (variations == "random") then
    return variations
  elseif type(variations) == 'table' then
    local result = {}
    for k,v in pairs(variations) do
      assert(type(k) == 'number', label .. " key " .. tostring(k) .. " is not a number")
      if (v == 'random') or type(v) == 'number' then
        result[k] = v
      else
        error(label .. " value " .. tostring(v) .. " is not supported")
      end
    end
    return result 
  end
end

local function getNode(...)
  local function f(t, k, ...)
    if k then
      if not t[k] then t[k] = {} end
      return f(t[k], ...)
    else
      return t
    end
  end
  return f(treeData, ...)
end

-- @param upgradeSpec
--     base the name of the base tree or the entity
--     upgrade the name of upgrade tree or the entity
--     probability the probability that this upgrade will be chosen, between 0 and 1
--     minDelay the minimum time until the upgrade will be applied if its chosen
--     minDelay the maximum time until the upgrade will be applied if its chosen
--     tiles either nil or true to allow all tiles,
--         or a dictionary from tile name to boolean allowing those tiles that are true
--     variations either the string "id" for identity (only works if both have the same number of variations)
--         or the string "random" for random variation
--         or a dictionary from int to either int (use that variation) or the string "random" (for a random variation)
-- 
function tree_growth.core.registerUpgrade(upgradeSpec)
  local baseName, baseEntity = resolveEntity("base", upgradeSpec.base)
  local upgradeName, upgradeEntity = resolveEntity("upgrade", upgradeSpec.upgrade) 
  
  local data = {
    name = upgradeName,
    probability = resolveProbability("probability", upgradeSpec.probability or 1),
    minDelay = resolveNumber("minDelay", upgradeSpec.minDelay),
    maxDelay = resolveNumber("maxDelay", upgradeSpec.maxDelay),
    tiles = resolveTileFilter("tiles", upgradeSpec.tiles),
    varations = resolveVariations("variations", upgradeSpec.varations),
  }
  if data.minDelay < 0 then
    error("minDelay must not be negative")
  end
  if data.minDelay > data.maxDelay then
    error("minDelay must not be larger than maxDelay")
  end
  
  -- store and persist
  table.insert(getNode(baseName, "upgrades"), data)
  persist(baseName)

  table.insert(getNode(upgradeName, "previous"), baseName)
  persist(upgradeName)

  -- TODO do we need this?
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


-- TODO rewrite to new form
tree_growth.core.registerOffspring = function(offspringSpec)
  local treeName, treeEntity = resolveEntity("parent", offspringSpec.parent)
  local saplingName, saplingEntity = resolveEntity("sapling", offspringSpec.sapling)
  
  local data = {
    name = saplingName,
    probability = resolveProbability("probability", offspringSpec.probability or 1),
    tiles = resolveTileFilter("tiles", offspringSpec.tiles),
    varations = resolveVariations("variations", offspringSpec.varations),
  }

  table.insert(getNode(treeName, "saplings"), data)
  persist(treeName)
  
  table.insert(getNode(saplingName, "parents"), treeName)
  persist(saplingName)
end
