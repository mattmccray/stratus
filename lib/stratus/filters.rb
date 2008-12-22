module Stratus
  
  module Filters

    def short_date(date)
      if date.respond_to? :strftime
        date.strftime('%m/%d/%Y')
      else
        "<!-- ??/??/???? -->"
      end
    end
    
    def date_to_xmlschema(date)
      date.xmlschema
    end
    
    def xml_escape(input)
      input.gsub("<", "&lt;").gsub(">", "&gt;")
    end
    
    def number_of_words(input)
      s = strip_html(CGI::unescapeHTML(input))
      s.gsub!(/[\w|\']+/, 'X')
      s.gsub!(/\W+/, '')
      s.length
    end
    
    # Moved to base resource...
    # def last(content)
    #   return nil unless content.is_a? Hash and content.has_key?('collection_type')
    #   collection = Stratus::Generator::LiquidContext.site_data[content['collection_type']]
    #   collection.last
    # end
    # 
    # def prev(content)
    #   return nil unless content.is_a? Hash and content.has_key?('collection_type')
    #   collection = Stratus::Generator::LiquidContext.site_data[content['collection_type']]
    #   collection.each_with_index do |c,i|
    #       return collection[(i - 1)] if c.slug == content['slug']
    #   end
    #   nil
    # end
    # 
    # def next(content)
    #   return nil unless content.is_a? Hash and content.has_key?('collection_type')
    #   collection = Stratus::Generator::LiquidContext.site_data[content['collection_type']]
    #   collection.each_with_index do |c,i|
    #       return collection[(i + 1)] if c.slug == content['slug']
    #   end
    #   nil
    # end
    # 
    # def first(content)
    #   return nil unless content.is_a? Hash and content.has_key?('collection_type')
    #   collection = Stratus::Generator::LiquidContext.site_data[content['collection_type']]
    #   collection.first
    # end
    
    EXTS = {
      '.rb'   => 'ruby',
      '.css'  => 'css',
      '.js'   => 'javascript',
      '.html' => 'html',
      '.xml'  => 'html'
    }
    LANG_BY_EXT = Hash.new {|h,k| h[k] = EXTS.fetch(k, 'text') }
    
    def sourcecode(input)
      if input.is_a? Hash
        source  = IO.readlines( input['source_path'] ).join
        %Q|<pre><code class="#{ LANG_BY_EXT[ input['ext'] ]}">#{escape(source)}</code></pre>|
      else
        "<pre><code>#{escape(input)}</code></pre>"
      end
    end

    def url(input)
      base_url = Stratus.setting('base_url', 'http://localhost', 'site')
      base_url + uri(input)
    end
    
    def uri(input)
      case input
      when Hash
        "/#{input['full_path']}"
      when Array
        "/#{input[0]['collection_type']}/index.html"
      when String
        input.starts_with?('/') ? input : "/#{input}"
      else
        "/#{input}"
      end
    end
    
    # deprecated!
    def uri_rel(input)
      uri(input)
    end
    
  end
  
end