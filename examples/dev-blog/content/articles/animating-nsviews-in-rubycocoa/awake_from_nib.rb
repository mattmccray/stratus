def awakeFromNib
  window.setContentSize @generalPrefsView.frame.size 
  window.contentView.addSubview @generalPrefsView
  window.title = "General Preferences"
  @currentViewTag = 0
  # Will use CoreAnimation for the panel changes:
  window.contentView.wantsLayer = true
end