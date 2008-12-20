module Stratus
  
class << self

  def settings
    # Use Mash for these?
    @settings ||= returning({}) do |conf|
      conf.merge! YAML::load( File.open(::Stratus.site_path('config', 'site.yaml')) )
      validate_settings
      conf['site']['time'] = Time.now
    end
  end
  
  def validate_settings
  end
  
  def setting(key, default=nil, section='site')
    if settings.has_key?(section) and settings[section].has_key?(key)
      settings[section][key]
    else
      default
    end
  end
  
  def content_settings
    @content_settings ||= returning({}) do |conf|
      conf.merge! YAML::load( File.open(::Stratus.site_path('config', 'content.yaml')) )
      validate_content_settings
    end
  end
  
  def validate_content_settings
  end
  
  def content_setting(type, key, default=nil)
    if content_settings.has_key?(type) and content_settings[type].has_key?(key)
      content_settings[type][key]
    elsif content_settings.has_key?('content') and content_settings['content'].has_key?(key)
      content_settings['content'][key]
    else
      default
    end
  end
  
end

end