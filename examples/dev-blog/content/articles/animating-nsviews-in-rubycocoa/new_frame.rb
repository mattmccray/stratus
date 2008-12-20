def newFrameForNewContentView(view)
  newFrameRect = window.frameRectForContentRect(view.frame)
  oldFrameRect = window.frame
  newSize = newFrameRect.size
  oldSize = oldFrameRect.size
  frame = window.frame
  frame.size = newSize
  frame.origin.y = frame.origin.y - (newSize.height - oldSize.height)
  frame
end