module Stratus::Generator

class Builder
  include Stratus::Logging
  
  def initialize(root_path, verbose=true)
    @root_path = root_path
    @verbose = verbose
  end
  
  def execute
    sweep_content
    render_content
    copy_theme_files
    
    info "Done.", "\n"
    growl "Build complete."
  end

  def sweep_content
    info "Scanning source structure..."
    scanner = Stratus::Generator::Scanner.new(@root_path)
    scanner.sweep
  end
  
  def render_content
    info "Rendering output..."
    make_dir Stratus.output_dir
    Stratus::Resources.collection_types.each do |col_type|
      info "#{col_type.capitalize}..."
      Stratus::Resources.content(:collection_type=>col_type).each do |r|
        output = renderer.render_content( r )
        write_file r.output_path, output
        # Copy attachments
        r.attachments.each do |attachment|
          copy_file attachment.source_path, attachment.output_path
        end
      end
      output = renderer.render_index_for( col_type )
      write_file Stratus.output_dir(col_type, 'index.html'), output
      if Stratus.content_setting( col_type, 'feed', true )
        output = renderer.render_index_for( col_type, 'feed' )
        write_file Stratus.output_dir(col_type, 'feed.xml'), output
      end
    end
    
    # Render HOME
    info "Homepage..."
    home = Stratus::Resources.homepage
    if home
      output = renderer.render_content( home, '.' )
      write_file Stratus.output_dir('index.html'), output
    else
      error "NO HOME PAGE DEFINED! UPDATE YOUR CONFIG FILE!!!"
    end
  end

  def copy_theme_files
    info "Theme..."
    delete_file Stratus.output_dir('theme'), true
    theme = Stratus.setting('theme', 'default')
    copy_file Stratus.site_path('themes', theme, 'images'), Stratus.output_dir('theme', 'images')
    copy_file Stratus.site_path('themes', theme, 'styles'), Stratus.output_dir('theme', 'styles')
    copy_file Stratus.site_path('themes', theme, 'scripts'), Stratus.output_dir('theme', 'scripts')
  end

protected

  def renderer
    @renderer ||= LiquidRenderer.new
  end
  
  # ================
  # = File Helpers =
  # ================
  
  def make_dir(path)
    FileUtils.mkdir_p( path )# unless File.exists?(path)
  end
  
  def write_file(path, contents)
    make_dir( File.dirname( path ) )
    File.open( path, 'w' ) do |f|
      f.write( contents )
      info(" + #{ path }", '.')
    end
  end
  
  def copy_file(path, to)
    unless File.exists?(path)
      info(" ? #{ to }", '.')
    else
      make_dir( File.dirname( to ) )
      FileUtils.cp_r path, to
      info(" - #{ to }", '.')
    end
  end
  
  def delete_file(path, force=false)
    return unless File.exists?(path)
    if force
      FileUtils.rm_rf( path )
    else
      FileUtils.rm( path )
    end
    info(" x #{ path }", '.')
  end

end

class << self
  
  def build(root_path)
    Builder.new(root_path).execute
  end
  
  def page_tree(root_path)
    builder = Builder.new(root_path)
    builder.sweep_content
    
    Stratus::Resources.collection_types.sort.each do |col_type|
      puts "#{ col_type }/"
      Stratus::Resources.content(:collection_type=>col_type, :sort_by=>:slug).each do |r|
        puts "   #{ r.slug }"
      end
    end
  end
  
end

end