module Stratus
  
  class SourcecodeTag < Liquid::Block
    include Liquid::StandardFilters

    Syntax = /['|"]+(.*)['|"]+/

    EXTS = {
      'rb'   => 'ruby',
      'ruby'   => 'ruby',
      'css'  => 'css',
      'js'   => 'javascript',
      'javascript'   => 'javascript',
      'html' => 'html',
      'xml'  => 'html'
    }
    LANG_BY_EXT = Hash.new {|h,k| h[k] = EXTS.fetch(k, k) }
    
    def initialize(tag_name, lang, tokens)
      super(tag_name, lang, tokens)
      if lang =~ Syntax
        @lang = LANG_BY_EXT[$1]
      else
        raise SyntaxError.new("Syntax Error in tag 'sourcecode' - Valid syntax: sourcecode [language]")
      end
    end
    
    def render(context)
      %Q|<pre><code class="#{@lang}">#{escape(super.to_s)}</code></pre>|
    end
  end

  ::Liquid::Template.register_tag('sourcecode', SourcecodeTag)
  
end

