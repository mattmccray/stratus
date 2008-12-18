module Stratus::Resources
  
  class << self
    
    # Every source file: Content, Attachment, (¿Template?)
    def all
      @all ||= HashDB.new
    end
    
    # Only content objects
    def collections(*args)
      filter = args.extract_options!.merge! :content_type=>:content
      all.find((args.first || :all), filter)
    end
    
    # Only content attachments
    def attachments(*args)
      filter = args.extract_options!.merge! :content_type=>:attachment
      all.find((args.first || :all), filter)
    end
    
    def posts(*args)
      filter = args.extract_options!.merge! :collection_type=>'posts', :content_type=>:content
      all.find((args.first || :all), filter)
    end
    
    def pages(*args)
      filter = args.extract_options!.merge! :collection_type=>'pages', :content_type=>:content
      all.find((args.first || :all), filter)
    end
    
    # Only templates
    def templates(*args)
      filter = args.extract_options!.merge! :content_type=>:template
      all.find((args.first || :all), filter)
    end

    # Only templates
    def layouts(*args)
      filter = args.extract_options!.merge! :content_type=>:layout
      all.find((args.first || :all), filter)
    end
    
    def clear
      all.clear
    end
    
  end
  
end

require 'stratus/resources/hash_db'
require 'stratus/resources/base'
require 'stratus/resources/attachment'
require 'stratus/resources/template'
require 'stratus/resources/layout'
require 'stratus/resources/content'
