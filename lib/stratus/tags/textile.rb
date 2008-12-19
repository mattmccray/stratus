module Stratus
  
  class TextileTag < Liquid::Block
#    include Liquid::StandardFilters
  
    def render(context)
      if defined?(RedCloth)
        RedCloth.new( super.to_s ).to_html
      else
        puts "You must had RedCloth installed to render textile!"
        super.to_s
      end
    end
  end

  ::Liquid::Template.register_tag('textile', TextileTag)
  
end

