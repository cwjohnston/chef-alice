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

package 'cpanminus'

deploy node[:alice][:root] do
  not_if {File.exists?("#{node[:alice][:root]}/deploy.lock")}
  repo node[:alice][:repo]
  revision node[:alice][:revision]
  symlink_before_migrate "" => ""
  symlinks "extlib" => "extlib"
  create_dirs_before_symlink [ ]
  before_restart do
    execute "setup alice extlib" do
      command "#{node[:alice][:root]}/shared/cpanm --notest --local-lib #{node[:alice][:root]}/shared/extlib Module::Install local::lib"
    end
    execute "install alice dependencies" do
      command "#{node[:alice][:root]}/shared/cpanm --notest --local-lib #{node[:alice][:root]}/shared/extlib --installdeps #{node[:alice][:root]}/current"
    end
  end 
end
