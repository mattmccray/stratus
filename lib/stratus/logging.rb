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
  
  def error
    puts msg
  end
  
  def fatal
    puts msg
  end
  
end

end