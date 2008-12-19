# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stratus}
  s.version = "0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["M@ McCray"]
  s.autorequire = %q{rake}
  s.date = %q{2008-12-19}
  s.default_executable = %q{stratus}
  s.description = %q{A simple static blog building tool.}
  s.email = %q{darthapo@gmail.com}
  s.executables = ["stratus"]
  s.files = ["Changelog", "Manifest", "Rakefile", "Readme.markdown", "bin/stratus", "lib/stratus.rb", "lib/stratus/cli.rb", "lib/stratus/filters.rb", "lib/stratus/generator.rb", "lib/stratus/generator/builder.rb", "lib/stratus/generator/context.rb", "lib/stratus/generator/renderer.rb", "lib/stratus/generator/scanner.rb", "lib/stratus/resources.rb", "lib/stratus/resources/attachment.rb", "lib/stratus/resources/base.rb", "lib/stratus/resources/content.rb", "lib/stratus/resources/hash_db.rb", "lib/stratus/resources/layout.rb", "lib/stratus/resources/template.rb", "lib/stratus/settings.rb", "lib/stratus/tags.rb", "lib/stratus/tags/markdown.rb", "lib/stratus/tags/textile.rb", "lib/stratus/tasks/app/boilerplate/StratusSite", "lib/stratus/tasks/app/boilerplate/config/defaults/page.default.html", "lib/stratus/tasks/app/boilerplate/config/defaults/post.default.html", "lib/stratus/tasks/app/boilerplate/config/site.yaml", "lib/stratus/tasks/app/boilerplate/content/pages/home/index.html", "lib/stratus/tasks/app/boilerplate/themes/default/styles/main.css", "lib/stratus/tasks/app/boilerplate/themes/default/templates/layouts/main.html", "lib/stratus/tasks/app/boilerplate/themes/default/templates/objects/page.html", "lib/stratus/tasks/app/boilerplate/themes/default/templates/objects/page.index.html", "lib/stratus/tasks/app/boilerplate/themes/default/templates/objects/post.html", "lib/stratus/tasks/app/boilerplate/themes/default/templates/objects/post.index.html", "lib/stratus/tasks/app/site.rake", "lib/stratus/tasks/shared/system.rake", "lib/stratus/tasks/site/new.rake", "lib/stratus/tasks/site/site.rake", "lib/stratus/tasks/site/theme.rake", "stratus.gemspec", "test/fixtures/site/StratusSite", "test/fixtures/site/config/defaults/article.default.html", "test/fixtures/site/config/defaults/content.default.html", "test/fixtures/site/config/defaults/page.default.html", "test/fixtures/site/config/defaults/post.default.html", "test/fixtures/site/config/site.yaml", "test/fixtures/site/content/articles/001_im-the-title/index.html", "test/fixtures/site/content/pages/about/index.html", "test/fixtures/site/content/pages/home/index.html", "test/fixtures/site/content/pages/projects/index.html", "test/fixtures/site/content/posts/001_new-blog/dom.js", "test/fixtures/site/content/posts/001_new-blog/index.html", "test/fixtures/site/content/posts/001_new-blog/old.html", "test/fixtures/site/content/posts/002_fun-for-the-whole-family/index.html", "test/fixtures/site/content/posts/002_fun-for-the-whole-family/snippet_one.rb", "test/fixtures/site/content/posts/003_life-is-quite-fun-really/index.html", "test/fixtures/site/themes/default/scripts/code_highlighter.js", "test/fixtures/site/themes/default/scripts/code_syntax.js", "test/fixtures/site/themes/default/styles/code_syntax.css", "test/fixtures/site/themes/default/styles/main.css", "test/fixtures/site/themes/default/templates/layouts/main.html", "test/fixtures/site/themes/default/templates/objects/article.html", "test/fixtures/site/themes/default/templates/objects/article.index.html", "test/fixtures/site/themes/default/templates/objects/feed.xml", "test/fixtures/site/themes/default/templates/objects/page.html", "test/fixtures/site/themes/default/templates/objects/page.index.html", "test/fixtures/site/themes/default/templates/objects/post.html", "test/fixtures/site/themes/default/templates/objects/post.index.html", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/darthapo/stratus/wikis}
  s.require_paths = ["lib"]
  s.requirements = ["rake", "active_support", "chronic", "hpricot", "liquid"]
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
