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

  def notify(type='', title='', msg='')
    puts msg
  end
  
  def fatal(msg)
    puts msg
  end
  
  def growl(message, title="Stratus Notification", type="stratus-notify")
    growler.notify type, title, message
    #notify(notify_type, title, message, priority = 0, sticky = false)
  end
  
  def growler
    @growler ||= begin
      if defined?(Growl)
        Growl.new( "localhost", "stratus", ["stratus-notify"])
      else
        self
      end
    end
  end
  
end

end


begin
  require 'ruby-growl'
rescue LoadError
  # If you had ruby-growl, stratus would use it.
end