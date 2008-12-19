module Stratus::Resources
require 'pp'
class Content < Base
  
  def validate!
    raise StandardError.new("Posts must have a publish-date! #{content_path}") if (!metadata.has_key?(:publish_date) and collection_type == 'posts')
    true
  end

  def full_path
    parent_path = super
    super.empty? ? "index.html" : "#{parent_path}/index.html"
  end
  
end

end