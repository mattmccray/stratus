module Stratus::Generator

# ==========
# = Liquid =
# ==========
class LiquidContext < Hash
  
  def initialize
    super
    self.merge!(self.class.site_data)
    self
  end
  
  class << self
    def path_to_root
      @path_to_root ||= ''
    end
    def path_to_root=(path)
      @path_to_root = path
    end
    
    def site_data
      @site_data ||= returning({}) do |data|
        data['site'] = Stratus.settings['site']
        data['vars'] =Stratus.settings.fetch('vars', {})
        Stratus::Resources.collection_types.each do |col_type|
          sort_col = Stratus.content_setting(col_type, 'sort', 'index').to_sym
          reversed = Stratus.content_setting(col_type, 'reverse', false)
          collection_data = Stratus::Resources.content(:collection_type=>col_type, :sort_by=>sort_col, :reverse=>reversed)
          data[col_type] = collection_data
          data[col_type.singularize] = hashify(collection_data)
        end
      end
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

end