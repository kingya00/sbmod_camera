function init()
  local objectConfig = root.assetJson("/objects/fakecamera/fakecamera.config:object")
  self.outputSlot = objectConfig.outputSlot
  self.offset = objectConfig.offset
  self.avatarPattern = objectConfig.avatarPattern
  self.pixelDivisor = objectConfig.pixelDivisor
  self.shutterTime = objectConfig.shutterTime
  self.shutterTimer = self.shutterTime
  self.active = false

  message.setHandler("prepare", function(_, _, ...)
      animator.playSound("shutter")
      self.active = true
      self.photoConfig = {...}
    end)
end

function update()
  if self.active then
    animator.setLightActive("flashLight", true)
    self.shutterTimer = math.max(self.shutterTimer - script.updateDt(), 0)
    if self.shutterTimer == 0 then
      animator.burstParticleEmitter("flash")
      takePhotos(table.unpack(self.photoConfig))
      self.shutterTimer = self.shutterTime
      self.active = false
      animator.setLightActive("flashLight", false)
    end
  end
end

function takePhotos(entityId, photoFrame, photoType, count)
  if world.entityExists(entityId) then
    local portrait = world.entityPortrait(entityId, "full")
    local photoframe = root.createItem(photoFrame)
    local parameters = {}
    parameters.layers = generateLayer(portrait, photoType)
    parameters.offset = self.offset[photoType]
    photoframe.parameters = parameters
    photoframe.count = count
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
        position = {layer.position[1] / self.pixelDivisor, layer.position[2] / self.pixelDivisor}
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
