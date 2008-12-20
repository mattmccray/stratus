ib_action :selectPrefPanel do |sender|
  tag =  sender.tag
  view, title = self.viewForTag(tag)
  previousView, prevTitle = self.viewForTag(@currentViewTag)
  @currentViewTag = tag
  newFrame = self.newFrameForNewContentView(view)
  window.title = "#{title} Preferences"
  # Using an animation grouping because we may be changing the duration
  NSAnimationContext.beginGrouping
    # Call the animator instead of the view / window directly
    window.contentView.animator.replaceSubview_with(previousView, view)
    window.animator.setFrame_display newFrame, true
  NSAnimationContext.endGrouping
end