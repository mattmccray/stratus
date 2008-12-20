module Stratus
  
module Logging
  
  # Use logging?
  def info(msg, alt=nil)
    if ENV['STRATUS_LOGGING'] == 'verbose'
      puts msg
    else
      print alt unless alt.nil?
      STDOUT.flush
    end
  end
  
  def error(msg)
    puts msg
  end
  
  def fatal(msg)
    puts msg
  end
  
end

end