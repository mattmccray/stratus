# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stratus}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["M@ McCray"]
  s.autorequire = %q{rake}
  s.date = %q{2008-12-23}
  s.default_executable = %q{stratus}
  s.description = %q{A simple static blog building tool.}
  s.email = %q{darthapo@gmail.com}
  s.executables = ["stratus"]
  s.files = ["Changelog", "Manifest", "Rakefile", "Readme.markdown", "bin/stratus", "examples/dev-blog/StratusSite", "examples/dev-blog/config/content.yaml", "examples/dev-blog/config/defaults/article.default.html", "examples/dev-blog/config/defaults/page.default.html", "examples/dev-blog/config/defaults/post.default.html", "examples/dev-blog/config/site.yaml", "examples/dev-blog/content/articles/animating-nsviews-in-rubycocoa/awake_from_nib.rb", "examples/dev-blog/content/articles/animating-nsviews-in-rubycocoa/ib_action.rb", "examples/dev-blog/content/articles/animating-nsviews-in-rubycocoa/index.html", "examples/dev-blog/content/articles/animating-nsviews-in-rubycocoa/new_frame.rb", "examples/dev-blog/content/articles/animating-nsviews-in-rubycocoa/outlets.rb", "examples/dev-blog/content/articles/animating-nsviews-in-rubycocoa/view_for_tag.rb", "examples/dev-blog/content/articles/im-the-title/index.html", "examples/dev-blog/content/articles/liquid-js-a-non-evaling-template-engine-in-javascript/html_test.html", "examples/dev-blog/content/articles/liquid-js-a-non-evaling-template-engine-in-javascript/index.html", "examples/dev-blog/content/articles/liquid-js-a-non-evaling-template-engine-in-javascript/liquid_example.js", "examples/dev-blog/content/pages/about/index.html", "examples/dev-blog/content/pages/home/index.html", "examples/dev-blog/content/pages/projects/index.html", "examples/dev-blog/content/posts/001_new-blog/dom.js", "examples/dev-blog/content/posts/001_new-blog/index.html", "examples/dev-blog/content/posts/001_new-blog/old.html", "examples/dev-blog/content/posts/002_fun-for-the-whole-family/index.html", "examples/dev-blog/content/posts/002_fun-for-the-whole-family/snippet_one.rb", "examples/dev-blog/content/posts/003_life-is-quite-fun-really/index.html", "examples/dev-blog/themes/default/scripts/code_highlighter.js", "examples/dev-blog/themes/default/scripts/code_syntax.js", "examples/dev-blog/themes/default/styles/code_syntax.css", "examples/dev-blog/themes/default/styles/main.css", "examples/dev-blog/themes/default/templates/articles/content.html", "examples/dev-blog/themes/default/templates/articles/feed.xml", "examples/dev-blog/themes/default/templates/articles/list.html", "examples/dev-blog/themes/default/templates/layouts/main.html", "examples/dev-blog/themes/default/templates/pages/content.html", "examples/dev-blog/themes/default/templates/pages/feed.xml", "examples/dev-blog/themes/default/templates/pages/list.html", "examples/dev-blog/themes/default/templates/posts/content.html", "examples/dev-blog/themes/default/templates/posts/feed.xml", "examples/dev-blog/themes/default/templates/posts/list.html", "lib/stratus.rb", "lib/stratus/cli.rb", "lib/stratus/filters.rb", "lib/stratus/generator.rb", "lib/stratus/generator/builder.rb", "lib/stratus/generator/context.rb", "lib/stratus/generator/renderer.rb", "lib/stratus/generator/scanner.rb", "lib/stratus/logging.rb", "lib/stratus/resources.rb", "lib/stratus/resources/attachment.rb", "lib/stratus/resources/base.rb", "lib/stratus/resources/content.rb", "lib/stratus/resources/hash_db.rb", "lib/stratus/resources/layout.rb", "lib/stratus/resources/template.rb", "lib/stratus/settings.rb", "lib/stratus/tags.rb", "lib/stratus/tags/markdown.rb", "lib/stratus/tags/sourcecode.rb", "lib/stratus/tags/textile.rb", "lib/stratus/tasks/app/boilerplate/StratusSite", "lib/stratus/tasks/app/boilerplate/config/content.yaml", "lib/stratus/tasks/app/boilerplate/config/defaults/page.default.html", "lib/stratus/tasks/app/boilerplate/config/defaults/post.default.html", "lib/stratus/tasks/app/boilerplate/config/site.yaml", "lib/stratus/tasks/app/boilerplate/content/pages/home/index.html", "lib/stratus/tasks/app/boilerplate/content/posts/001_welcome/index.html", "lib/stratus/tasks/app/boilerplate/content/posts/002_getting-started/index.html", "lib/stratus/tasks/app/boilerplate/themes/default/images/footer-bg.png", "lib/stratus/tasks/app/boilerplate/themes/default/images/page-bg.png", "lib/stratus/tasks/app/boilerplate/themes/default/scripts/site.js", "lib/stratus/tasks/app/boilerplate/themes/default/styles/main.css", "lib/stratus/tasks/app/boilerplate/themes/default/templates/layouts/main.html", "lib/stratus/tasks/app/boilerplate/themes/default/templates/pages/content.html", "lib/stratus/tasks/app/boilerplate/themes/default/templates/pages/feed.xml", "lib/stratus/tasks/app/boilerplate/themes/default/templates/pages/list.html", "lib/stratus/tasks/app/boilerplate/themes/default/templates/posts/content.html", "lib/stratus/tasks/app/boilerplate/themes/default/templates/posts/feed.xml", "lib/stratus/tasks/app/boilerplate/themes/default/templates/posts/list.html", "lib/stratus/tasks/app/site.rake", "lib/stratus/tasks/shared/system.rake", "lib/stratus/tasks/site/new.rake", "lib/stratus/tasks/site/site.rake", "lib/stratus/tasks/site/theme.rake", "lib/stratus/version.rb", "stratus.gemspec", "test/test_helper.rb"]
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
