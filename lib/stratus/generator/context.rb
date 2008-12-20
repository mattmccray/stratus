module Stratus::Generator

# ==========
# = Liquid =
# ==========
class LiquidContext < Hash
  
  def initialize
    super
    site_data = {
      'site'  => Stratus.settings['site'],
      'vars'  => Stratus.settings.fetch('vars', {})
    }
    Stratus::Resources.collection_types.each do |col_type|
      sort_col = Stratus.content_setting(col_type, 'sort', 'index').to_sym
      reversed = Stratus.content_setting(col_type, 'reverse', false)
      collection_data = Stratus::Resources.content(:collection_type=>col_type, :sort_by=>sort_col, :reverse=>reversed)
#      puts "#{col_type}: #{collection_data.length} items... (sorted by #{sort_col}#{reversed ? ', reversed': ''})"
      site_data[col_type] = collection_data
      site_data[col_type.singularize] = hashify(collection_data)
    end
    self.merge!(site_data)
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