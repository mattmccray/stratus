namespace :site do

  desc "Generate static html (default)"
  task :build=>'system:setup' do
    Stratus::Generator.build(ROOT_PATH)
  end

  desc "Removes generated output"
  task :cleanup=>'system:setup' do
    FileUtils.rm_rf Stratus.output_dir
    puts "  Done."
  end

  desc "Upgrades site so it's compatible with the installed version of stratus"
  task :upgrade=>'system:setup' do
    puts "  Up to date."
  end

end

task :default=>'site:build'