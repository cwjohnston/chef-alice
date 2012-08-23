# recipe: alice::default
# this recipe licensed under apache license 2.0

user node[:alice][:user] do
  system true
end

package "libssl-dev"

include_recipe "git"
include_recipe "perl"
include_recipe "build-essential"

if node[:alice][:run_standalone]
  include_recipe "runit"
  runit_service "alice"

  service "alice" do
    supports :status => true, :restart => true
  end
end

directory "#{node[:alice][:root]}/shared" do
  recursive true
  owner node[:alice][:user]
  group node[:alice][:user]
end

execute "setup alice extlib" do
  command "cpanm --notest --local-lib #{node[:alice][:root]}/shared/extlib Module::Install local::lib"
  user node[:alice][:user]
  not_if "perl -I#{node[:alice][:root]}/shared/extlib/lib/perl5/ -Mlocal::lib=#{node[:alice][:root]}/shared/extlib -mModule::Install -e ''"
end

deploy node[:alice][:root] do
  user node[:alice][:user]
  group node[:alice][:user]
  not_if {File.exists?("#{node[:alice][:root]}/deploy.lock")}
  repo node[:alice][:repo]
  revision node[:alice][:revision]
  symlink_before_migrate "" => ""
  symlinks "extlib" => "extlib"
  create_dirs_before_symlink [ ]
  before_restart do
    execute "install alice dependencies" do
      command "cpanm --notest --local-lib #{node[:alice][:root]}/shared/extlib --installdeps #{node[:alice][:root]}/current"
    end
  end 
end
