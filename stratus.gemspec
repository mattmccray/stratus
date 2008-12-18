# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stratus}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["M@ McCray"]
  s.autorequire = %q{rake}
  s.date = %q{2008-12-18}
  s.default_executable = %q{stratus}
  s.description = %q{A simple static blog building tool.}
  s.email = %q{darthapo@gmail.com}
  s.executables = ["stratus"]
  s.files = ["Changelog", "Manifest", "Rakefile", "Readme.markdown", "bin/stratus", "lib/stratus.rb", "lib/stratus/cli.rb", "lib/stratus/filters.rb", "lib/stratus/generator.rb", "lib/stratus/generator/builder.rb", "lib/stratus/generator/context.rb", "lib/stratus/generator/renderer.rb", "lib/stratus/generator/scanner.rb", "lib/stratus/resources.rb", "lib/stratus/resources/attachment.rb", "lib/stratus/resources/base.rb", "lib/stratus/resources/content.rb", "lib/stratus/resources/hash_db.rb", "lib/stratus/resources/layout.rb", "lib/stratus/resources/template.rb", "lib/stratus/settings.rb", "lib/stratus/tags/textile.rb", "lib/stratus/tasks/app/site.rake", "lib/stratus/tasks/shared/system.rake", "lib/stratus/tasks/site/new.rake", "lib/stratus/tasks/site/site.rake", "lib/stratus/tasks/site/theme.rake", "stratus.gemspec", "test/fixtures/site/StratusSite", "test/fixtures/site/config/site.yaml", "test/fixtures/site/content/pages/001_about/index.html", "test/fixtures/site/content/pages/002_projects/index.html", "test/fixtures/site/content/posts/001_new-blog/index.html", "test/fixtures/site/content/posts/001_new-blog/old.html", "test/fixtures/site/content/posts/002_fun-for-the-whole-family/index.html", "test/fixtures/site/skin/styles/main.css", "test/fixtures/site/skin/templates/layouts/main.html", "test/fixtures/site/skin/templates/objects/feed.xml", "test/fixtures/site/skin/templates/objects/home.html", "test/fixtures/site/skin/templates/objects/page.html", "test/fixtures/site/skin/templates/objects/page.index.html", "test/fixtures/site/skin/templates/objects/post.html", "test/fixtures/site/skin/templates/objects/post.index.html", "test/fixtures/site/www/index.html", "test/fixtures/site/www/pages/about/index.html", "test/fixtures/site/www/pages/index.html", "test/fixtures/site/www/pages/projects/index.html", "test/fixtures/site/www/posts/fun-for-the-whole-family/index.html", "test/fixtures/site/www/posts/index.html", "test/fixtures/site/www/posts/new-blog/index.html", "test/fixtures/site/www/posts/new-blog/old.html", "test/fixtures/site/www/skin/styles/main.css", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/darthapo/stratus/wikis}
  s.require_paths = ["lib"]
  s.requirements = ["rake", "active_support", "chronic", "hpricot"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A simple static blog building tool.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
