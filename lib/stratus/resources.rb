module Stratus::Resources
  
  class << self
    
    # Every source file: Content, Attachment, (¿Template?)
    def all
      @all ||= HashDB.new
    end
    
    def register_content(content)
      content.fixup_meta
      if content.validate! # Should allow returning false to exclude from DB
        collection_types << content.collection_type unless collection_types.include?( content.collection_type )
        all << content
      else
        puts " - Skipping #{content.content_path}: failed validation"
      end
    end
    
    def homepage
      @all.find(:first, :is_homepage=>true)
    end

    def collection_types
      @collecton_types ||= []
    end
    
    # Only content objects
    def content(*args)
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
