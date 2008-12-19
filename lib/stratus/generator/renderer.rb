module Stratus::Generator

# ==========
# = Liquid =
# ==========
class LiquidRenderer
  
  attr_reader :context
  
  def initialize
    @context = LiquidContext.new
  end
  
  def render_content(content, path_to_root='../../')
    in_context do
      LiquidContext.path_to_root = path_to_root
      context['this'] = content
      template = template_for(content.collection_type, nil)
      context['content'] = parser_for(template).render(context, [Stratus::Filters])
      layout = layout_for(template)
      parser_for(layout).render(context, [Stratus::Filters])
    end
  end
  
  # Currently unused... 
  def render_content_fragment(content, state=nil)
    in_context do
      #LiquidContext.path_to_root = '../../' ???
      context['this'] = content
      template = template_for(content.collection_type, state)
      parser_for(template).render(context, [Stratus::Filters])
    end
  end
  
  def render_index_for(collection_type, state='index')
    in_context do
      LiquidContext.path_to_root = state.nil? ? '' : '../'
      template = template_for(collection_type, state)
      context['content'] = parser_for(template).render(context, [Stratus::Filters])
      layout = layout_for(template)
      parser_for(layout).render(context, [Stratus::Filters])
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
  
  # loops through all the metadata fields and processes them through Liquid...
  # def render_attributes(content)
  #   rendered_atts = {}
  #   context['this'] = content
  #   content.to_liquid.each do |key, value|
  #     if value.is_a? String
  #       puts "Rendering #{key} (#{value})"
  #       rendered_atts[key] = Liquid::Template.parse(value).render(context, [Stratus::Filters])
  #     end
  #   end
  #   rendered_atts
  # end
  
  
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