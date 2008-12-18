module Stratus::Resources

# A rudimentary "database" for holding resource objects and finding them.
# The database is held in a Ruby hash keyed by the collection/slug
# Based on Webby's DB class...
class HashDB
  attr_reader :db
  
  def initialize
    @db = Hash.new {|h,k| h[k] = []}
  end
  
  def add( content )
    ary = @db[content.content_path]
    
    # make sure we don't duplicate contents
    ary.delete content if ary.include? content
    ary << content
    
    content
  end
  alias :<< :add
  
  def clear
    @db.clear
    self
  end
  
  def each( &block )
    keys = @db.keys.sort
    keys.each do |k|
      @db[k].sort.each(&block)
    end
    self
  end
  
  # FIXME: Need to add support for:
  #   collection/*
  #   */*
  def find( *args, &block )
    opts = Hash === args.last ? args.pop : {}
    
    limit = args.shift
    limit = opts.delete(:limit) if opts.has_key?(:limit)
    sort_by = opts.delete(:sort_by)
    reverse = opts.delete(:reverse)
    
    # figure out which collections to search through
    search = self
    
    # construct a search block if one was not supplied by the user
    block ||= lambda do |content|
      found = true
      opts.each do |key, value|
        if key == :content_path
          found &&= content.__send__(key.to_sym).match( Regexp.new( value.gsub('*', '.*'), 'g' ) )
        else
          found &&= content.__send__(key.to_sym) == value
        end
        break if not found
      end
      found
    end
    
    # search through the collections for the desired content objects
    ary = []
    search.each do |content|
      ary << content if block.call(content)
    end
    
    # sort the search results if the user gave an attribute to sort by
    if sort_by
      m = sort_by.to_sym
      ary.delete_if {|p| p.__send__(m).nil?}
      reverse ? 
          ary.sort! {|a,b| b.__send__(m) <=> a.__send__(m)} :
          ary.sort! {|a,b| a.__send__(m) <=> b.__send__(m)} 
    end
    
    # limit the search results
    case limit
    when :all, 'all'
      ary
    when Integer
      ary.slice(0,limit)
    else
      ary.first
    end
  end
  
  def siblings( content, opts = {} )
    ary = @db[content.content_path].dup
    ary.delete content
    return ary unless opts.has_key? :sort_by
    
    m = opts[:sort_by]
    ary.sort! {|a,b| a.__send__(m) <=> b.__send__(m)}
    ary.reverse! if opts[:reverse]
    ary
  end

end  # class 
end  # module 

# EOF

# Webby's LICENCE:
# MIT License
# Copyright (c) 2007 - 2008
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# 'Software'), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sub-license, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
