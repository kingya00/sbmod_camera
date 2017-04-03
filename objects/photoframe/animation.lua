function init()
  script.setUpdateDelta(5)
end

function update()
  localAnimator.clearDrawables()

  local layers = animationConfig.animationParameter("layers") or nil
  if layers then
    for _, layer in pairs(layers) do
      localAnimator.addDrawable(layer)
    end
  end
end
