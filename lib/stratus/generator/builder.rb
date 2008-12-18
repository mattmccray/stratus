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
    
    info "Validation..."
    Stratus::Resources.all.each do |r|
      r.fixup_meta
      r.validate!
    end
    
    #pp conf( :output )
    
    #info "Removing stale output"

    info "Rendering output..."
    make_dir Stratus.output_dir
    Stratus::Resources.posts.each do |r|
      output = renderer.render_content( r )
      write_file r.output_path, fix_up_paths(output)
      # Copy attachments
      r.attachments.each do |attachment|
        copy_file attachment.source_path, attachment.output_path
      end
      
    end
    output = renderer.render_index_for( 'posts', 'index' )
    write_file Stratus.output_dir('posts', 'index.html'), fix_up_paths(output)

    Stratus::Resources.pages.each do |r|
      output = renderer.render_content( r )
      write_file r.output_path, fix_up_paths(output)
      # Copy attachments
      r.attachments.each do |attachment|
        copy_file attachment.source_path, attachment.output_path
      end
    end
    output = renderer.render_index_for( 'pages', 'index' )
    write_file Stratus.output_dir('pages', 'index.html'), fix_up_paths(output)

    # Render HOME
    output = renderer.render_index_for( 'home', nil )
    write_file Stratus.output_dir('index.html'), fix_up_paths(output)
    
    # TODO: Render FEED

    # Copy skin files... ?
    delete_file Stratus.output_dir('skin'), true
    copy_file Stratus.site_path('skin', 'images'), Stratus.output_dir('skin', 'images')
    copy_file Stratus.site_path('skin', 'styles'), Stratus.output_dir('skin', 'styles')
    copy_file Stratus.site_path('skin', 'scripts'), Stratus.output_dir('skin', 'scripts')

    # pp Stratus::Resources.all.db
  end

protected

  def renderer
    @renderer ||= LiquidRenderer.new
  end
  
  def conf(key, section='generator')
    Stratus.settings[section][key]
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
  
  def fix_up_paths(output, path_to_root='/')
    # doc = Hpricot(output)
    #     doc.search("//[@src]") do |elem|
    #       unless elem[:src] =~ /^(http|mailto|\/)/
    #         puts "src: #{elem[:src]}"
    #       end
    #     end
    #     puts "looking for @href"
    #     doc.search("//[@href]") do |elem|
    #       unless elem[:href] =~ /^(http|mailto|\/)/
    #         puts "href: #{elem[:href]}"
    #       end
    #     end
    #     
    #     doc.to_html
    output
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