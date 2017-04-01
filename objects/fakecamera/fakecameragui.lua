function init()
  self.photoType = 1
  self.backgroundType = 1
  self.backgroundImages = {
    {"/interface/scripted/terraformer/bar_cursor_base.png", "/interface/scripted/terraformer/bar_cursor_hover.png",  "/interface/scripted/terraformer/bar_cursor_disabled.png"},
    {"/interface/scripted/terraformer/bar_cursor_base.png", "/interface/scripted/terraformer/bar_cursor_hover.png",  "/interface/scripted/terraformer/bar_cursor_disabled.png"}
  }
end

function update(dt)
  updatePriview()
end

function updatePriview()
  widget.setImage("priview", self.backgroundImages[self.photoType][self.backgroundType])
end

function takePhoto()
  pane.dismiss()
end

function photoTypeSelector()
  self.photoType = widget.getSelectedOption("photoTypeSelector")
end

function backgroundTypeSelector()
  self.backgroundType = widget.getSelectedOption("backgroundTypeSelector")
end
