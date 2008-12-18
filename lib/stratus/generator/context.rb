module Stratus::Generator

# ==========
# = Liquid =
# ==========
class LiquidContext < Hash
  
  def initialize
    super
    self.merge!({
      'site'  => Stratus.settings['site'],
      'posts' => Stratus::Resources.posts(:sort_by=>:publish_date, :reverse=>true),
      'post'  => hashify( Stratus::Resources.posts ),
      'pages' => Stratus::Resources.pages(:sort_by=>:title),
      'page'  => hashify( Stratus::Resources.pages )
    })
    self
  end
  
  def self.path_to_root
    @@path_to_root ||= ''
  end
  def self.path_to_root=(path)
    @@path_to_root = path
  end
  
protected
  
  def hashify(list)
    returning({}) do |h|
      list.each do |item|
        h[item.slug] = item
      end
    end
  end
  
end

end