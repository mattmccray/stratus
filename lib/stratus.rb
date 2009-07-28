module Stratus
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  
  
  class << self
    def args
      @args || []
    end
    def args=(value)
      @args = value
    end

    def site_path(*args)
      @site_path ||= File.expand_path('.')
      args.empty? ? @site_path : ::File.join(@site_path, args.flatten)
    end
    def site_path=(value)
      @site_path = value
    end
    
    def output_dir(*args)
      @output_dir ||= settings['generator'].fetch('output', 'www')
      args.empty? ? @output_dir : ::File.join(@output_dir, args.flatten)
    end
    
    def libpath( *args )
      args.empty? ? LIBPATH : ::File.join(LIBPATH, args.flatten)
    end
  
  end
  
end

def safely_require(lib)
  require lib
rescue LoadError
  puts "  ! Couldn't load: #{lib}"
end

require 'rubygems'
require 'chronic'
require 'hpricot'
require 'active_support'
require 'liquid'
safely_require 'redcloth'
safely_require 'maruku'

# Other types of markup tools?

#require 'cgi' # for HTML Escaping...
#require 'bluecloth' rescue LoadError

require 'stratus/version'
require 'stratus/logging'
require 'stratus/generator'
require 'stratus/resources'
require 'stratus/settings'
require 'stratus/filters'
require 'stratus/tags'

class String
  def slugify
    downcase.gsub(/&/, ' and ').gsub(/[^a-z0-9']+/, '-').gsub(/^-|-$|'/, '')
  end
end

# function slugify(str) {
#   return str.toLowerCase().
#              replace(/&/g, 'and').
#              replace(/[^a-z0-9']+/g, '-').
#              replace(/^-|-$/g, '');
# }