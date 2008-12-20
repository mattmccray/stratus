require 'rubygems'
require 'optparse'
require 'rake'

ENV['STRATUS_LOGGING'] = 'verbose'

module Stratus

class CLI
  
  def initialize(out)
    @out = out
    @mode = :site
  end
  
  def run(args)
    args = args.dup
    parse args
    init args
    rake
  end
  
  # Parse the command line _args_ for options and commands to invoke.
  def parse( args )
    opts = OptionParser.new
    opts.banner = 'Usage: stratus [options] target [target args]'

    opts.separator ''

    desired_opts = %[--describe --prereqs --tasks --trace]
    app.standard_rake_options.each do |options|
      next unless desired_opts.include?(options.first)
      opts.on(*options)
    end

    opts.separator ''
    opts.separator 'common options:'

    opts.on_tail( '-h', '--help', 'show this message' ) do
      @out.puts opts
      exit
    end
    opts.on_tail( '-q', '--quiet', 'show compact messages' ) do
      ENV['STRATUS_LOGGING'] = 'quiet'
    end
    opts.on_tail( '--version', 'show version' ) do
      @out.puts "Stratus #{::Stratus::VERSION}"
      exit
    end
    
    begin
      opts.parse! args
    rescue OptionParser::InvalidOption => ex
      puts "!! #{ex}"
    end
    
    
    ARGV.replace Array(args.shift)
    args.delete_if do |arg|
      if %r/^[A-Z_]+=/ =~ arg
        ARGV << arg
        next true
      end
      false
    end

    args
  end

  # Initialize the Rake application object and load the core rake tasks, the
  # site specific rake tasks, and the site specific ruby code. Any extra
  # command line arguments are converted into a page name and directory that
  # might get created (depending upon the task invoked).
  def init( args )
    # Make sure we're in a folder with a Sitefile
    options = app.standard_rake_options
    [['--rakefile', 'StratusSite'],
     ['--no-search', nil],
     ['--silent', nil]].each {|opt, value| options.assoc(opt).last.call(value)}

    unless app.have_rakefile
      @mode = :app
    end

    import_default_tasks
    import_website_tasks
    require_lib_files
    capture_command_line_args(args)
    
    # if args.length  == 0 && @mode == :app
    #   puts "Try using:\n  stratus -T"
    # end
    
    args
  end

  # Execute the rake command.
  #
  def rake
    app.init 'stratus'
    app.load_rakefile
    app.top_level
  end

  # Return the Rake application object.
  #
  def app
    Rake.application
  end

  # Returns the options hash from the Rake application object.
  #
  def options
    app.options
  end

  def import_default_tasks
    path = (@mode == :app)? %w(stratus tasks app *.rake) : %w(stratus tasks site *.rake)
    Dir.glob(::Stratus.libpath(path)).sort.each {|fn| load fn}
    Dir.glob(::Stratus.libpath(%w(stratus tasks shared *.rake))).sort.each {|fn| load fn}
  end

  def import_website_tasks
    return if (@mode == :app)
    Dir.glob(::File.join(%w[tasks *.rake])).sort.each {|fn| load fn}
  end

  def require_lib_files
    return if (@mode == :app)
    Dir.glob(::File.join(%w[lib ** *.rb])).sort.each {|fn| require fn}
  end

  def capture_command_line_args(args)
    ::Stratus.args = args # set the args in a place where all rake tasks can read 'em
    ::Stratus.site_path = File.expand_path('.')
    args
  end
  
  class << self
    def run(args, out=STDOUT)
      self.new(out).run(args)
    end
  end
  
end

end


# :stopdoc:
# Monkey patches so that rake displays the correct application name in the
# help messages.
#
class Rake::Application
  def display_prerequisites
    tasks.each do |t|
      puts "#{name} #{t.name}"
      t.prerequisites.each { |pre| puts "    #{pre}" }
    end
  end

  def display_tasks_and_comments
    displayable_tasks = tasks.select { |t|
      t.comment && t.name =~ options.show_task_pattern
    }
    if options.full_description
      displayable_tasks.each do |t|
        puts "#{name} #{t.name_with_args}"
        t.full_comment.split("\n").each do |line|
          puts "    #{line}"
        end
        puts
      end
    else
      width = displayable_tasks.collect { |t| t.name_with_args.length }.max || 10
      max_column = truncate_output? ? terminal_width - name.size - width - 7 : nil
      displayable_tasks.each do |t|
        printf "#{name} %-#{width}s  # %s\n",
          t.name_with_args, max_column ? truncate(t.comment, max_column) : t.comment
      end
    end
  end

  # Provide standard execption handling for the given block.
  def standard_exception_handling
    begin
      yield
    rescue SystemExit => ex
      # Exit silently with current status
      exit(ex.status)
    rescue SystemExit, OptionParser::InvalidOption => ex
      # Exit silently
      exit(1)
    rescue Exception => ex
      return if ex.message =~ /Rakefile/
      # Exit with error message
      $stderr.puts "#{name} aborted!"
      $stderr.puts "!> #{ex.message}"
      if options.trace
        $stderr.puts ex.backtrace.join("\n")
      else
        $stderr.puts ex.backtrace.find {|str| str =~ /#{@rakefile}/ } || ""
        $stderr.puts "(See full trace by running task with --trace)"
      end
      exit(1)
    end
  end
end  # class Rake::Application
# :startdoc:

# EOF
