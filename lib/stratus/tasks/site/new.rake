namespace :new do

  desc "Creates a content object"
  task :content=>'system:setup' do
    if Stratus.args.length < 2
      puts "  You must specify a collection type and title" 
      exit(1)
    end
    
    require 'erb'
    content_type = Stratus.args[0]
    content_type = content_type.pluralize if !File.exists?( Stratus.site_path('content', content_type))
    
    if !File.exists?( Stratus.site_path('content', content_type))
      puts "Collection '#{content_type}' not found!"
      exit(1)
    end
    
    title = Stratus.args[1]
    slug = title.slugify
    date = Time.now
    slug_prefix = case Stratus.content_setting(content_type, 'local_slug', 'index')
      when 'none'
        ''
      when 'index'
        (Dir[Stratus.site_path('content', content_type, '*')].length + 1).to_s.rjust(3, '0')
      when 'date'
        date.strftime( Stratus.content_setting(content_type, 'slug_format', '%Y-%m-%d-') )
    end
    template = ERB.new(CONTENT_TEMPLATE)
    body = template.result(binding)
    dir_path = Stratus.site_path('content', content_type, "#{slug_prefix}_#{slug}")
    file_path = File.join(dir_path, 'index.html')
    
    FileUtils.mkdir_p dir_path
    File.open(file_path, 'w') do |f|
      f.write body
    end
    
    puts "Created #{file_path}"
    `$EDITOR #{file_path}` if ENV.has_key? 'EDITOR'
  end

  desc "Creates a collection"
  task :collection=>'system:setup' do
    if Stratus.args.length == 0
      puts "  You must specify a collection name" 
      exit(1)
    end
    require 'erb'
    name = Stratus.args[0].slugify
    single = name.singularize
    puts "Creating #{name}"
    current_theme = Stratus.setting('theme', 'default')
    
    FileUtils.mkdir_p( Stratus.site_path('content', name)  )
    File.open( Stratus.site_path('themes', current_theme, 'templates', 'objects', "#{single}.html"), 'w') do |f|
      template = ERB.new(COLLECTION_TEMPLATE)
      body = template.result(binding)
      f.write body
    end
    File.open( Stratus.site_path('themes', current_theme, 'templates', 'objects', "#{single}.index.html"), 'w') do |f|
      template = ERB.new(COLLECTION_INDEX_TEMPLATE)
      body = template.result(binding)
      f.write body
    end
    File.open( Stratus.site_path('config', 'defaults', "#{single}.default.html"), 'w' ) do |f|
      f.write CONTENT_DEFAULT_TEMPLATE
    end
  end
  
end

CONTENT_TEMPLATE=<<-EOF
<head>
  <title><%= title %></title>
  <meta name="publish-date" content="<%= date.strftime('%Y-%m-%d %H:%M') %>"/>
</head>
<summary>
  <p>SUMMARY</p>
</summary>
<body>
  <p>I'm the main body.</p>
</body>
EOF

POST_TEMPLATE=<<-EOF
<head>
  <title><%= title %></title>
  <meta name="publish-date" content="<%= date.strftime('%Y-%m-%d %H:%M') %>"/>
</head>
<summary>
  <p>SUMMARY</p?
</summary>
<body>
  <p>I'm the main body.</p>
</body>
EOF

CONTENT_DEFAULT_TEMPLATE=<<-EOF
<head>
  <title>{{ title }}</title>
  <meta name="publish-date" content="{{ date | date:'%Y-%m-%d %H:%M' }}"/>
</head>
<summary>
  <p>SUMMARY</p>
</summary>
<body>
  <p>BODY.</p>
</body>
EOF

COLLECTION_TEMPLATE=<<-EOF
<meta name="layout" content="main"/>
<div class="<%= single %>">
  <h2>{{ this.title }}</h2>
  <div class="body">
    {{ this.body }}
  </div>
</div>
EOF

COLLECTION_INDEX_TEMPLATE=<<-EOF
<meta name="layout" content="main">
<div class="<%= name %>">
{% for <%= single %> in <%= name %> %}
  <div class="<%= single %> summary">
    <h2><a href="{{ <%= single %> | uri_rel }}">{{ <%= single %>.title }}</a></h2>
  </div>
{% endfor %}
</div>
EOF
