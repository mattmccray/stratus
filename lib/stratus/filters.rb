module Stratus
  
  module Filters
    def date_to_string(date)
      date.strftime("%d %b %Y")
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
    
    def link(input)
      if input.is_a? ::Stratus::Resources::Base
        "/#{input.full_path}"
      else
        "/#{input}"
      end
    end
    
    def link_rel(input)
      case input
      when Hash
        "#{Stratus::Generator::LiquidContext.path_to_root}#{input['full_path']}"
      when Array
        "#{Stratus::Generator::LiquidContext.path_to_root}#{input[0]['collection_type']}/index.html"
      else
        "#{Stratus::Generator::LiquidContext.path_to_root}#{input}"
      end
    end
    
  end
  
end