function init()
  local guiConfig = root.assetJson("/objects/fakecamera/fakecamera.config:gui")
  self.photoType = 1
  self.backgroundType = 1
  self.count = 0
  self.photoTypes = guiConfig.photoTypes
  self.backgroundImages = guiConfig.backgroundImages
  self.buttonImages = guiConfig.buttonImages
  self.buttonCheckedImages = guiConfig.buttonCheckedImages
  self.checkboxes = guiConfig.checkboxes
  self.photoFrames = guiConfig.photoFrames
  self.imageScaler = guiConfig.imageScaler
  self.backgroundPosition = guiConfig.backgroundPosition
  self.spinnerPrefix = guiConfig.spinnerPrefix
  self.spinnerPrefixLength = string.len(self.spinnerPrefix)
  self.spinnerInitValue = guiConfig.spinnerInitValue

  initSpinner()
end

function update(dt)
  updateButtonImages()
  updatePreview()
  updateActionButton()
end

function updatePreview()
  widget.setPosition("preview", self.backgroundPosition[self.photoType])
  widget.setImage("preview", self.backgroundImages[self.photoType][self.backgroundType])
  widget.setImageScale("preview", self.imageScaler[self.photoType])
end

function updateButtonImages()
  for checkbox, index in pairs(self.checkboxes) do
    widget.setButtonImages(checkbox, self.buttonImages[self.photoType][index])
    if widget.getChecked(checkbox) then
      widget.setButtonCheckedImages(checkbox, self.buttonCheckedImages[self.photoType][index])
    end
  end
end

function updateActionButton()
  if self.count > 0 then
    widget.setButtonEnabled("takePhoto", true)
  else
    widget.setButtonEnabled("takePhoto", false)
  end
end

function takePhoto()
  world.sendEntityMessage(pane.containerEntityId(), "prepare", pane.playerEntityId(), self.photoFrames[self.photoType][self.backgroundType], self.photoTypes[self.photoType], self.count)
  pane.dismiss()
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

function initSpinner()
  widget.setText("tbSpinCount", self.spinnerPrefix .. self.spinnerInitValue)
end

function updateCount()
  local str = widget.getText("tbSpinCount")
  local count = str and tonumber(string.sub(str, self.spinnerPrefixLength + 1)) or 0
  self.count = count
end

spinCount = {
  up = function()
    local str = widget.getText("tbSpinCount")
    local count = str and tonumber(string.sub(str, self.spinnerPrefixLength + 1)) or 0
    count = count + 1
    self.count = count
    widget.setText("tbSpinCount", tostring(self.spinnerPrefix .. count))
  end,
  down = function()
    local str = widget.getText("tbSpinCount")
    local count = str and tonumber(string.sub(str, self.spinnerPrefixLength + 1)) or 0
    count = math.max(count - 1, 0)
    self.count = count
    widget.setText("tbSpinCount", tostring(self.spinnerPrefix .. count))
  end
}
