function init()
  local guiConfig = root.assetJson("/objects/fakecamera/fakecamera.config:gui")
  self.photoType = 1
  self.backgroundType = 1
  self.photoTypes = guiConfig.photoTypes
  self.backgroundImages = guiConfig.backgroundImages
  self.buttonImages = guiConfig.buttonImages
  self.buttonCheckedImages = guiConfig.buttonCheckedImages
  self.checkboxes = guiConfig.checkboxes
end

function update(dt)
  updateButtonImages()
  updatePriview()
end

function updatePriview()
  widget.setImage("preview", self.backgroundImages[self.photoType][self.backgroundType])
end

function updateButtonImages()
  for checkbox, index in pairs(self.checkboxes) do
    widget.setButtonImages(checkbox, self.buttonImages[self.photoType][index])
    if widget.getChecked(checkbox) then
      widget.setButtonCheckedImages(checkbox, self.buttonCheckedImages[self.photoType][index])
    end
  end
end

function takePhoto()
  world.sendEntityMessage(pane.containerEntityId(), "takePhotos", pane.playerEntityId(), self.photoTypes[self.photoType])
end

function photoTypeSelector()
  self.photoType = widget.getSelectedOption("photoTypeSelector")
end

function selectBackground01()
  backgroundSelector("background01Button")
end

function selectBackground02()
  backgroundSelector("background02Button")
end

function selectBackground03()
  backgroundSelector("background03Button")
end

function backgroundSelector(id)
  widget.setChecked(id, true)
  self.backgroundType = self.checkboxes[id]
  for checkbox, _ in pairs(self.checkboxes) do
    if checkbox ~= id then
      widget.setChecked(checkbox, false)
    end
  end
end
