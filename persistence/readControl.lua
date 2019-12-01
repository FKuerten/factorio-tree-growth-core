local readFlyingText = function(textName)
  local textPrototype = game.entity_prototypes[textName]
  if not textPrototype then return nil end
  local order = textPrototype.order
  return order
end

local parseData = function(serializedData)
  local dataFunc = loadstring(serializedData)
  if not dataFunc then return nil end
  --assert(dataFunc, "no data for " .. treeName .. " order=" .. order)
  local data = dataFunc()
  return data
end

function getTreeData(treeName)
  local textName = 'tree-growth-core-' .. treeName

  local serializedData = ""
  local chunkIndex = 1
  while true do
    local chunkName = textName .. "-" .. chunkIndex
    local serializedDataChunk = readFlyingText(chunkName)
    if not serializedDataChunk then break end
    serializedData = serializedData .. serializedDataChunk
    chunkIndex = chunkIndex + 1
    --game.print(chunkName .. serializedDataChunk)
  end
  local data = parseData(serializedData)
  return data
end
