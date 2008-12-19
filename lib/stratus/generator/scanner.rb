require 'fileutils'

module Stratus::Generator

class Scanner
  attr_reader :base, :content_path

  def initialize(base_path)
    @base = File.expand_path(base_path)
    raise StandardError.new("Base path must be a directory.") unless File.directory?(base)
    
  end
  
  def sweep(clear_db=true)
    @content_path = File.join(base, 'content')
    resources.clear if clear_db
    sweep_content
    sweep_templates
    sweep_layouts
  end

private
  
  def sweep_content
    Dir[File.join(content_path, '*', '*')].each do |fullpath|
      object_path = fullpath.gsub( "#{ content_path }/", '')
      collection = object_path.split('/').first
      object = Stratus::Resources::Content.new(fullpath, object_path)
      resources.register_content( object )
      sweep_attachments fullpath, object
    end
    # Set indices for all content...
    Stratus::Resources.collection_types.each do |col_type|
      count = 1
      resources.all.find(:collection_type=>col_type, :sort_by=>:publish_date).each do |r|
        r.index = count if r.index.nil?
        count += 1
      end
    end
  end
  
  def sweep_attachments(from_path, content_object)
    Dir[File.join(from_path, '*')].each do |filename|
      next if File.basename(filename) == 'index.html'
      resources.all << Stratus::Resources::Attachment.new(filename, content_object)
    end
  end

  def sweep_templates
    templates_path = File.join(base, 'themes', Stratus.setting('theme', 'default'), 'templates', 'objects')
    Dir[File.join(templates_path, '*')].each do |fullpath|
      object_path = fullpath.gsub( "#{ templates_path }/", '')
      template = Stratus::Resources::Template.new(fullpath, "templates/#{object_path}")
      resources.all << template
    end
  end

  def sweep_layouts
    layouts_path = File.join(base, 'themes', Stratus.setting('theme', 'default'), 'templates', 'layouts')
    Dir[File.join(layouts_path, '*')].each do |fullpath|
      object_path = fullpath.gsub( "#{ layouts_path }/", '')
      layout = Stratus::Resources::Layout.new(fullpath, "layouts/#{object_path}")
      resources.all << layout
    end
  end
  
  def resources
    Stratus::Resources
  end

end



end