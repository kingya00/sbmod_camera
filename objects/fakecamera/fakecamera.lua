function init()
  local objectConfig = root.assetJson("/objects/fakecamera/fakecamera.config:object")
  self.outputSlot = objectConfig.outputSlot
  self.offset = objectConfig.offset
  self.photoItem = objectConfig.photoItem
  self.avatarPattern = objectConfig.avatarPattern

  message.setHandler("takePhotos", function(_, _, entityId, photoType)
      takePhotos(entityId, photoType)
    end)
end

function update()

end

function takePhotos(entityId, photoType)
  if world.entityExists(entityId) then
    --animator.playSound("shutter")
    --animator.burstParticleEmitter("flash")
    local portrait = world.entityPortrait(entityId, "full")
    local photoframe = root.createItem(self.photoItem)
    local parameters = {}
    parameters.layers = generateLayer(portrait, photoType)
    parameters.offset = self.offset[photoType]
    photoframe.parameters = parameters
    world.containerPutItemsAt(entity.id(), photoframe, self.outputSlot)
  end
end

function generateLayer(portrait, photoType)
  local layers = {}
  local offset = self.offset[photoType]
  for _, drawables in pairs(portrait) do
    local layer
    if photoType == "half" and isAvatarLayer(drawables) then
      layer = drawables
    elseif photoType == "full" then
      layer = drawables
    end
    if layer then
      table.insert(layers, {
        image = layer.image,
        color = layer.color,
        fullbright = layer.fullbright,
        position = layer.position
      })
    end
  end
  return layers
end

function isAvatarLayer(layer)
  for _, pattern in ipairs(self.avatarPattern) do
    if string.find(layer.image, pattern) then
      return true
    end
  end
  return false
end
