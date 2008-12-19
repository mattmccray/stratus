module Stratus
  
class << self
  def settings
    # Use Mash for these?
    @settings ||= YAML::load( File.open(::Stratus.site_path('config', 'site.yaml')) )
  end
  
  def setting(key, default=nil, section='site')
    if settings.has_key?(section) and settings[section].has_key?(key)
      settings[section][key]
    else
      default
    end
  end
  
end

end