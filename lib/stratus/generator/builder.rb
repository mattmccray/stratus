module Stratus::Generator

class Builder
  
  def initialize(root_path, verbose=true)
    @root_path = root_path
    @verbose = verbose
  end
  
  def execute
    info "Scanning source structure..."
    scanner = Stratus::Generator::Scanner.new(@root_path)
    scanner.sweep
  
    info "Rendering output..."
    make_dir Stratus.output_dir
    Stratus::Resources.posts.each do |r|
      output = renderer.render_content( r )
      write_file r.output_path, output
      # Copy attachments
      r.attachments.each do |attachment|
        copy_file attachment.source_path, attachment.output_path
      end
      
    end
    output = renderer.render_index_for( 'posts', 'index' )
    write_file Stratus.output_dir('posts', 'index.html'), output

    Stratus::Resources.pages.each do |r|
      output = renderer.render_content( r )
      write_file r.output_path, output
      # Copy attachments
      r.attachments.each do |attachment|
        copy_file attachment.source_path, attachment.output_path
      end
    end
    output = renderer.render_index_for( 'pages', 'index' )
    write_file Stratus.output_dir('pages', 'index.html'), output

    # Render HOME
    home = Stratus::Resources.homepage
    if home
      output = renderer.render_content( home, '.' )
      write_file Stratus.output_dir('index.html'), output
    else
      puts "NO HOME PAGE DEFINED! UPDATE YOUR CONFIG FILE!!!"
    end
    # TODO: Render FEED

    copy_theme_files

    #pp Stratus::Resources.all.db 
  end

  def copy_theme_files
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
  
  
  # Use logging?
  def info(msg, alt=nil)
    if @verbose
      puts msg
    else
      puts alt unless alt.nil?
    end
  end
  
  def error
    puts msg
  end
  
  def fatal
    puts msg
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
    make_dir( File.dirname( to ) )
    FileUtils.cp_r path, to
    info(" - #{ to }", '.')
  end
  
  def delete_file(path, force=false)
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
  
end

end