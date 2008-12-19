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
      input.split.length
    end
    
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
        %Q|<pre><code class="#{ LANG_BY_EXT[ input['ext'] ]}">#{source}</code></pre>|
      else
        "<pre><code>#{input}</code></pre>"
      end
    end

    def url(input)
      base_url = Stratus.settings('base_url', nil, 'feed')
      base_url + uri(input)
    end
    
    def uri(input)
      case input
      when Hash
        "/#{input['full_path']}"
      when Array
        "/#{input[0]['collection_type']}/index.html"
      else
        "/#{input}"
      end
    end
    
    def uri_rel(input)
      uri(input)
    end
    
  end
  
end