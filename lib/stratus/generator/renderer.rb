module Stratus::Generator

# ==========
# = Liquid =
# ==========
class LiquidRenderer
  
  attr_reader :context
  
  def initialize
    @context = LiquidContext.new
  end
  
  def render_content(content, path_to_root='../..')
    in_context do
      context['this'] = content
      template = template_for(content.collection_type, 'content')
      context['content'] = parser_for(template).render(context, [Stratus::Filters])
      layout = layout_for(template)
      output = if layout.nil?
        context['content']
      else
        parser_for(layout).render(context, [Stratus::Filters])
      end
      fixup_paths(output, path_to_root)
    end
  end
  
  # Currently unused... 
  # def render_content_fragment(content, state=nil)
  #   in_context do
  #     context['this'] = content
  #     template = template_for(content.collection_type, state)
  #     output = parser_for(template).render(context, [Stratus::Filters])
  #     fixup_paths(output, ')
  #   end
  # end
  
  def render_index_for(collection_type, state='list')
    in_context do
      template = template_for(collection_type, state)
      context['content'] = parser_for(template).render(context, [Stratus::Filters])
      layout = layout_for(template)
      output = if layout.nil?
        context['content']
      else
        output = parser_for(layout).render(context, [Stratus::Filters])
      end
      fixup_paths(output, (state.nil? ? '.' : '..'))
    end
  end
  
protected
  
  # Allows all context changes to be scoped
  def in_context(&block)
    old_context = @context.clone
    results = yield
    @context = old_context
    results
  end
  
  def fixup_paths(output, path_to_root='.')
    opts = {
      :fixup_tags   => Stratus.setting('cleanup_xhtml', true, 'generator'),
      :xhtml_strict =>Stratus.setting('force_xhtml', false, 'generator')
    }
    doc = Hpricot(output, opts)
    if Stratus.setting('relative_links', true, 'generator')
      doc.search("//[@src]") do |elem|
        if elem[:src].starts_with? '/'
          elem[:src] = path_to_root + elem[:src] 
        end
      end
      doc.search("//[@href]") do |elem|
        if elem[:href].starts_with? '/'
          elem[:href] = path_to_root + elem[:href] 
        end
      end
    end
    doc.to_html
  end 
  
  def parser_for(template)
    @parsers ||= Hash.new {|h,k| 
      h[k] = ::Liquid::Template.parse(k.body)
    }
    @parsers[template]
  end
  
  def template_for(collection_type, state=nil)
    @templates ||= Hash.new {|h,k|
      ext = (k.last == 'feed') ? 'xml' : 'html'
      slugname = k.last.nil? ? "#{ k.first }.#{ ext }" : "#{ k.first }.#{ k.last }.#{ ext }"
      template = ::Stratus::Resources.templates(:first, :slug => slugname )
      raise StandardError.new("Template not found! #{slugname}") if template.nil?
      # if template.nil?
      #   slugname = k.last.nil? ? "default.html" : "default.#{ k.last }.html"
      #   template = ::Stratus::Resources.templates(:first, :slug => slugname )
      # end
      h[k] = template
    }
    @templates[ [collection_type, state] ]
  end

  def layout_for(template)
    @layouts ||= Hash.new {|h,k|
      h[k] = if k.empty?
        nil
      else
        Stratus::Resources.layouts(:first, :slug => "#{ k }.html")
      end
    }
    
    @layouts[ template.metadata.fetch(:layout, 'main') ]
  end
  
end

end