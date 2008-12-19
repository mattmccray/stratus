module Stratus::Resources
=begin

content_path:
  - pages/about
  - posts/20081105-my-slugline

content_type:
  - content
  - attachment

collection_type:
  - pages
  - posts

slug:
  - about
  - 20081105-my-slugline

=end

class Base
  attr_reader :index, :slug, :content_path, :collection_type, :content_type, :source_path

  def initialize(fullpath, content_path='', parse=:index)
    @source_path = fullpath
    @slug = File.basename(fullpath)
    @content_type = :content
    @content_path = content_path
    @collection_type = content_path.split('/').first
    @parse_mode = parse
    @is_template = false
    @index = if @slug =~ /^([\d]{3})_(.*)$/
      @slug = $2
#      @content_path = "#{collection_type}/#{slug}"
      $1.to_i
    else
      nil
    end
    
    case parse
    when :index
      parse_file(File.join(source_path, 'index.html'))
    when :file
      parse_file(source_path)
    when :template
      @is_template = true
      parse_file(source_path)
    else
      puts "Not parsing #{fullpath}"
    end
  end

  def metadata
    @meta ||= {} # Hash.new {|h,k| h[k] = []}
  end

  def full_path
    is_homepage ? "" : "#{ collection_type }/#{ @slug }"
  end
  
  def output_path
    File.join(Stratus.output_dir, @collection_type, @slug, 'index.html')
  end
  
  def attachments
    Stratus::Resources.attachments( :content_path=>content_path )
  end
  
  def attachments_hash
    returning( {} ) do |hash|
      attachments.each do |att|
        slug = att.slug.gsub(att.metadata[:ext], '')
        hash[slug] = att
      end
    end
  end
  

  def method_missing(name, *args)
    if name.to_s.ends_with? '='
      metadata[name.to_s[0..-2].to_sym] = args.first
    else
      metadata[name]
    end
  end

  def <=>( other )
    return unless other.kind_of? Stratus::Resources::Base
    self.content_path <=> other.content_path
  end

  def [](key)
    if self.respond_to? key.to_sym
      self.send(key.to_sym)
    else
      metadata[key]
    end
  end
  def []=(key, value)
    if self.respond_to? key.to_sym
      self.send(key.to_sym)
    else
      metadata[key] = value
    end
  end
  
  def is_homepage
    Stratus.setting('homepage') == content_path
  end
  
  def next_content
    Stratus::Resources.content(:first, :collection_type=>@collection_type, :index=>(@index + 1)) unless index.nil?
  end

  def prev_content
    Stratus::Resources.content(:first, :collection_type=>@collection_type, :index=>(@index - 1)) unless index.nil?
  end
  
  def to_liquid
    data = rendered_attributes({
      'slug'             => @slug,
      'content_path'     => @content_path,
      'collection_type'  => @collection_type,
      'content_type'     => @content_type,
      'full_path'        => full_path,
      'source_path'      => source_path,
      'attachments'      => attachments,
      'attachment'       => attachments_hash,
      'next'             => next_content,
      'prev'             => prev_content,
      'is_homepage'      => is_homepage
    })
  end
  
  # Subclasses need to override this to ensure all the proper metadata exists
  def validate!
    true
  end
  
  def fixup_meta
    if metadata.has_key? :tags
      tags = [metadata[:tags]].flatten.join(',')
      tags = tags.split(',')
      tags.map {|t| t.strip! }
      metadata[:tags] = tags
    end
    if metadata.has_key? :category
      cats = [metadata[:category]].flatten.join(',')
      cats = cats.split(',')
      cats.map {|t| t.strip! }
      metadata[:categories] = cats
    end
    if metadata.has_key? :publish_date
      metadata[:publish_date] = Chronic.parse( metadata[:publish_date] )
    else
      metadata[:publish_date] = Time.now
    end
  end
  
protected

  def rendered_attributes(rendered_atts={})
    context = Stratus::Generator::LiquidContext.new
    context['this'] = rendered_atts
    metadata.each do |key, value|
      if value.is_a? String
        rendered_atts[key.to_s] = Liquid::Template.parse(value).render(context, [Stratus::Filters])
      else
        rendered_atts[key.to_s] = value
      end
    end
    rendered_atts
  end

  def parse_file(filename)
    load_filedata(filename)
    if File.size(filename) == 0
      puts "!! File cannot be empty: #{@slug}"
      # throw an error?
      return
    end
    doc = Hpricot( open(filename) )
    
    # Only grab root level meta tags for layouts and templates...
    meta_q = (@is_template)? "/meta" : "//meta"
    
    doc.search(meta_q).each do |meta_tag|
      name = meta_tag[:name].gsub(' ', '_').gsub('-', '_').downcase.to_sym
      # Coerce the meta data value if it's defined...
      content = if meta_tag[:type]
        case meta_tag[:type].downcase.to_sym
        when :int
          meta_tag[:content].to_i
        when :integer
          meta_tag[:content].to_i
        when :float
          meta_tag[:content].to_f
        when :double
          meta_tag[:content].to_f
        when :array
          meta_tag[:content].split(',')
        when :list
          meta_tag[:content].split(',')
        when :date
          Chronic.parse( meta_tag[:content] )
        else
          meta_tag[:content]
        end
      else
        meta_tag[:content]
      end
      # Create an array of values for a meta key if it's the second time it's used
      if metadata.has_key? name
        metadata[name] = [metadata[name]] unless metadata[name].is_a? Array
        metadata[name] << content
      else
        metadata[name] = content
      end
    end
    # Now, remove the meta tags...
    doc.search(meta_q).remove

    if @parse_mode == :index # Content objects
      doc.search("//title").each do |title_tag|
        metadata[:title] = title_tag.inner_html
      end
      doc.search("//title").remove
    
      # Whatever's left in the header, we'll pull out here...
      metadata[:head] =  doc.at("head").inner_html.squish
    
      doc.search("//head").remove

      # Grab the rest of the root level nodes and add their inner_html
      # as metadata as well...
      doc.search("/*").each do |tag|
        metadata[tag.name.to_sym] = tag.inner_html unless tag.blank? or tag.is_a?( Hpricot::Text )
      end

    else # The rest
      metadata[:body] = doc.to_html
    end
  end
  
  def load_filedata(filename)
    metadata[:filename] = File.basename(filename)
    metadata[:ext]      = File.extname(filename)
    metadata[:mtime]    = File.mtime(filename)
    metadata[:ctime]    = File.ctime(filename)
    metadata[:size]     = File.size(filename)
  end
  
  
end

end