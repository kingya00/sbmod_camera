function init()
  self.initLayers = config.getParameter("layers")
  self.offset = config.getParameter("offset")
  initLayers()
end

function update(dt)
  if self.layers then
    object.setAnimationParameter("layers", self.layers)
  end
end

function initLayers()
  self.layers = deepCopy(self.initLayers)
  local offset = addPosition(object.position(), self.offset)
  for _, layer in pairs(self.layers) do
    layer.position = addPosition(layer.position, offset)
  end
end

function addPosition(pos1, pos2)
  return {pos1[1] + pos2[1], pos1[2] + pos2[2]}
end

function deepCopy(orig)
  local copy
  if type(orig) == "table" then
    copy = {}
    for key, value in pairs(orig) do
      copy[deepCopy(key)] = deepCopy(value)
    end
    setmetatable(copy, getmetatable(orig))
  else
    copy = orig
  end
  return copy
end

function die()
  world.spawnItem(object.name(), object.position(), 1, {
    layers = self.initLayers,
    offset = self.offset
  })
end
