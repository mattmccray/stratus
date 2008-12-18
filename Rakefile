$: << 'lib'
require 'rake'
require 'rake/testtask'
require 'rake/gempackagetask'
require 'stratus'

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "A simple static blog building tool."
  s.name = 'stratus'
  s.version = Stratus::VERSION
  s.author = 'M@ McCray'
  s.email = 'darthapo@gmail.com'
  s.homepage = 'http://github.com/darthapo/stratus/wikis'
  
  s.requirements << 'rake'
  s.requirements << 'active_support'
  s.requirements << 'chronic'
  s.requirements << 'hpricot'
  s.require_path = 'lib'
  s.autorequire = 'rake'
  s.files = File.read("Manifest").split
  s.executables = s.files.grep(/bin/) { |f| File.basename(f) }
  s.description = <<EOF
A simple static blog building tool.
EOF
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

namespace :gem do
  desc "Create the gemspec file"
  task :spec do
    File.open("stratus.gemspec", "w") do |file|
      file.puts spec.to_ruby
    end
  end
end

desc 'Clean up'
task :clean => :clobber_package do
  %w(diff diff email ri *.gem **/*~).each do |pattern|
    files = Dir[pattern]
    rm_rf files unless files.empty?
  end
end

namespace :manifest do
  desc "Verify the manifest"
  task :check => :clean do
    f = "Manifest.tmp"
    require 'find'
    files = []
    Find.find '.' do |path|
      next unless File.file? path
      next if path =~ /\.git|tmp$|\.DS_Store/
      files << path[2..-1]
    end
    files = files.sort.join "\n"
    File.open f, 'w' do |fp| fp.puts files end
    system "diff -du Manifest #{f}"
    rm f
  end

  desc "Create the manifest"
  task :create => :clean do
    f = "Manifest"
    require 'find'
    files = []
    Find.find '.' do |path|
      next unless File.file? path
      next if path =~ /\.git|tmp$|\.DS_Store/
      files << path[2..-1]
    end
    files = files.sort.join "\n"
    File.open f, 'w' do |fp| fp.puts files end
  end
end
