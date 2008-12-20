def viewForTag(tag)
  case tag
    when 0: [@generalPrefsView,  "General"]
    when 1: [@advancedPrefsView, "Advanced"]
  end
end