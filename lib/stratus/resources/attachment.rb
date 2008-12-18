module Stratus::Resources

class Attachment < Base
  
  attr_reader :parent

  def initialize(fullpath, content_object)
    super(fullpath, content_object.content_path, :file)
    @parent = content_object
    @content_type = :attachment
    @content_path = parent.content_path
    @collection_type = parent.collection_type
  end
  
  def validate!
    #raise StandardError.new("Posts must have a published-on date! #{content_path}") unless metadata.has_key?(:publish_on)
    true
  end
  
  def full_path
    "#{@parent.collection_type}/#{@parent.slug}/#{@slug}"
  end
  
  def output_path
    File.join(Stratus.output_dir, full_path)
  end

protected

  def parse_file(filename)
    load_filedata(filename)
  end

end

end
