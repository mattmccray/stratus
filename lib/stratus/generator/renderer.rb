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
      template = template_for(content.collection_type, nil)
      context['content'] = parser_for(template).render(context, [Stratus::Filters])
      layout = layout_for(template)
      output = parser_for(layout).render(context, [Stratus::Filters])
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
  
  def render_index_for(collection_type, state='index')
    in_context do
      template = template_for(collection_type, state)
      context['content'] = parser_for(template).render(context, [Stratus::Filters])
      layout = layout_for(template)
      output = parser_for(layout).render(context, [Stratus::Filters])
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
    doc = Hpricot(output)
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
      slugname = k.last.nil? ? "#{ k.first.singularize }.html" : "#{ k.first.singularize }.#{ k.last }.html"
#      puts "Looking for #{ slugname }"
      template = ::Stratus::Resources.templates(:first, :slug => slugname )
      if template.nil?
        slugname = k.last.nil? ? "_default.html" : "_default.#{ k.last }.html"
#        puts "Not found, resorting to #{ slugname }"
        template = ::Stratus::Resources.templates(:first, :slug => slugname )
      end
      h[k] = template
    }
    @templates[ [collection_type, state] ]
  end

  def layout_for(template)
    @layouts ||= Hash.new {|h,k| 
      h[k] = ::Stratus::Resources.layouts(:first, :slug => "#{ k }.html")
    }
    @layouts[ template.metadata.fetch('layout', 'main') ]
  end
  
end

end