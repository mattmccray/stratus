module Stratus::Resources

class Layout < Template
  
  def initialize(fullpath, content_path='')
    super(fullpath, content_path)
    @content_type = :layout
  end

  def validate!
    metadata[:layout] = nil unless metadata.has_key? :layout
    #raise StandardError.new("Posts must have a published-on date! #{content_path}") unless metadata.has_key?(:publish_on)
    true
  end
  
end

end