# recipe: alice::default
# this recipe licensed under apache license 2.0

package "libssl-dev"

include_recipe "git"
include_recipe "perl"
include_recipe "runit"
include_recipe "build-essential"

runit_service "alice"

service "alice" do
  supports :status => true, :restart => true
end

%w{ shared/cached-copy releases }.each do |d|
  directory "#{node[:alice][:root]}/#{d}" do
    recursive true
  end
end

remote_file "#{node[:alice][:root]}/shared/cpanm" do
  source "https://github.com/miyagawa/cpanminus/raw/master/cpanm"
  mode 0755
  owner "root"
  group "root"
  not_if{File.exists?("#{node[:alice][:root]}/shared/cpanm")}
end

deploy node[:alice][:root] do
  not_if {File.exists?("#{node[:alice][:root]}/deploy.lock")}
  repo node[:alice][:repo]
  revision node[:alice][:revision]
  symlink_before_migrate "" => ""
  symlinks "" => ""
  create_dirs_before_symlink [ ]
  before_restart do
    execute "install alice dependencies" do
      command "#{node[:alice][:root]}/shared/cpanm --notest --local-lib #{node[:alice][:root]}/extlib Module::Install local::lib"
      command "#{node[:alice][:root]}/shared/cpanm --notest --local-lib #{node[:alice][:root]}/extlib --installdeps #{node[:alice][:root]}"
    end
  end 
end
