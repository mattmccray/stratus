namespace :new do
  
  desc "Creates a new page"
  task :page=>'system:setup' do
    if Stratus.args.length == 0
      puts "  You must specify a page title" 
      exit(1)
    end
    
  end

  desc "Creates a new blog post"
  task :post=>'system:setup' do
    if Stratus.args.length == 0
      puts "  You must specify a post title" 
      exit(1)
    end
    require 'erb'
    title = Stratus.args[0]
    slug = title.slugify
    date = Time.now
    count = (Dir[File.join(ROOT_PATH, 'content', 'posts', '*')].length + 1).to_s.rjust(3, '0')
    template = ERB.new(POST_TEMPLATE)
    body = template.result(binding)
    dir_path = File.join(ROOT_PATH, 'content', 'posts', "#{count}_#{slug}")
    file_path = File.join(dir_path, 'index.html')
    
    FileUtils.mkdir_p dir_path
    File.open(file_path, 'w') do |f|
      f.write body
    end
    puts "Created #{file_path}"
  end
  
end

POST_TEMPLATE=<<-EOF
<head>
  <title><%= title %></title>
  <meta name="publish-date" content="<%= date.strftime('%Y-%m-%d %H:%M') %>"/>
</head>
<summary>
I'll be visible on index page, rss feed and probably the post page (depends on the layout).
</summary>
<body>
I'm the main body.
</body>
EOF
