#!/usr/bin/env rake

current_dir = File.dirname(__FILE__)
cookbook_path = '/tmp/alice-cookbooks'
data_bag_path = '/tmp/alice-data_bags'

@cookbook = "alice"

desc "install dependencies using Berkshelf"
task :install_deps do
  system("berks install --shims #{cookbook_path}")
  system("ln -sfv #{File.join(current_dir,'data_bags')} #{data_bag_path}")
end

desc "Runs foodcritic linter"
task :foodcritic do
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sandbox = File.join(File.dirname(__FILE__), %w{tmp foodcritic}, @cookbook)
    prepare_foodcritic_sandbox(sandbox)

    sh "foodcritic --epic-fail any #{File.dirname(sandbox)}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

task :default => 'foodcritic'

private

def prepare_foodcritic_sandbox(sandbox)
  files = %w{*.md *.rb attributes definitions files providers
    recipes resources templates}

  rm_rf sandbox
  mkdir_p sandbox
  cp_r Dir.glob("{#{files.join(',')}}"), sandbox
  puts "\n\n"
end
