module Stratus
  
class << self
  def settings
    @settings ||= YAML::load( File.open(::Stratus.site_path('config', 'site.yaml')) )
  end
end

end