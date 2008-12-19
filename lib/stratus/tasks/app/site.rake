class String
  def /(other)
    File.join(self, other)
  end
end


namespace :new do
  
  desc "Creates a new stratus blog"
  task :site=>'system:setup' do
    if Stratus.args.length == 0
      puts "  You must specify a site (folder) name" 
      exit(1)
    end
    site_name = Stratus.args[0]
    site_path = File.expand_path(File.join(ROOT_PATH, site_name))
    if File.exists?(site_path) and !File.directory?(site_path)
      puts " Target is a file!"
      exit(1)
    else
      FileUtils.mkdir_p( site_path )
    end
    template = Dir[File.join( File.dirname(__FILE__), 'boilerplate', "*" )]
    FileUtils.cp_r template, site_path
    
    puts <<-EOF
Done! You can create your first post by:

  cd #{site_name}
  stratus new:post "My First Post"

You can build the website by running:

  stratus site:build

To see all of the available commands, run:

  stratus -T

Enjoy!
EOF
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


STRATUS_SITE_TEMPLATE =<<-EOF

EOF

SITE_YAML_TEMPLATE =<<-EOF

EOF