function init()
  self.layers = config.getParameter("layers")
  self.offset = config.getParameter("offset")
  initLayers()
end

function update(dt)
  if self.layers then
    object.setAnimationParameter("layers", self.layers)
  end
end

function initLayers()
  local position = object.position()
  for _, layer in ipairs(self.layers) do
    layer.position = addPosition(position, self.offset)
  end
end

function addPosition(pos1, pos2)
  return {pos1[1] + pos2[1], pos1[2] + pos2[2]}
end

function die()
  world.spawnItem(object.name(), object.position(), 1, {
    layers = self.layers,
    offset = self.offset
  })
end
