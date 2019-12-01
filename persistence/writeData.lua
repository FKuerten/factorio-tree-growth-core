tree_growth = tree_growth or {}
tree_growth.core = tree_growth.core or {}

local chunkSize = 200

local serialize = function(treeData)
  local serializedData = serpent.dump(treeData)
  return serializedData
end

local storeInFlyingText = function(textName, serializedData)
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

tree_growth.core.persist = function(treeName, treeData)
  assert(treeName, "need a name to persist")
  local textName = 'tree-growth-core-' .. treeName
  local serializedData = serialize(treeData)
  
  local length = serializedData:len()
  local chunks = math.ceil(length / chunkSize)
  for chunkIndex = 1, chunks do
    local chunkName = textName .. "-" .. chunkIndex
    local chunkStart = (chunkIndex - 1) * chunkSize + 1
    local serializedDataChunk = serializedData:sub(chunkStart, chunkStart + chunkSize - 1)
    storeInFlyingText(chunkName, serializedDataChunk)
  end
end
