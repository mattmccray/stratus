
namespace :new do
  
  desc "Creates a new stratus blog"
  task :site do
    if Stratus.args.length == 0
      puts "  You must specify a site (folder) name" 
      exit(1)
    end

    puts "Site: #{Stratus.args.inspect}"
  end
  
  
end

task :show_usage do
  puts "Stratus #{Stratus::VERSION}. For more information run:"
  puts
  puts "  stratus -h"
  puts
  puts "For a complete list of commands available in this context, run:"
  puts
  puts "  stratus -T"
  puts
end

task :default => :show_usage