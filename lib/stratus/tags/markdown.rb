module Stratus
  
  class MarkdownTag < Liquid::Block
#    include Liquid::StandardFilters
  
    def render(context)
      # if defined?(BlueCloth)
      #   BlueCloth.new( super.to_s ).to_html
      # else
      #   puts "You must had BlueCloth installed to render textile!"
      #   super.to_s
      # end
      if defined?(Maruku)
        Maruku.new( super.to_s ).to_html
      else
        puts "You must had Maruku installed to render textile!"
        super.to_s
      end
    end
  end

  ::Liquid::Template.register_tag('markdown', MarkdownTag)

end

