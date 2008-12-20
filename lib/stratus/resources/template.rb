module Stratus::Resources

class Template < Base
  
  def initialize(fullpath, content_path='')
    super(fullpath, content_path, :template)
    @content_type = :template
  end
  
  def validate!
#    puts "SETTING LAYOUT TO 'main' for #{content_path}" unless metadata.has_key? :layout
    metadata[:layout] = 'main' unless metadata.has_key? :layout
    #raise StandardError.new("Posts must have a published-on date! #{content_path}") unless metadata.has_key?(:publish_on)
#    puts "LAYOUT = '#{metadata[:layout]}'" 
    true
  end
  
  def full_path
    content_path
  end
  
end

end