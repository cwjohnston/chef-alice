include_recipe "runit"
include_recipe "alice::default"
include_recipe "database"

user node[:catlady][:user] do
  system true
end

%w{ shared shared/etc/users shared/var .cpanm }.each do |dir|
  directory "#{node[:catlady][:root]}/#{dir}" do
    recursive true
    owner node[:catlady][:user]
    group node[:catlady][:user]
  end

  execute "fix ownership of #{node[:catlady][:root]}/#{dir}" do
    command "chown -R #{node[:catlady][:user]}.#{node[:catlady][:user]} #{node[:catlady][:root]}/#{dir}"
  end
end

link "#{node[:catlady][:root]}/shared/extlib" do
  to "#{node[:alice][:root]}/shared/extlib"
end

include_recipe 'alice::_catlady_config'

mysql_config = {:host => node[:catlady][:db][:hostname], :username => 'root', :password => node[:mysql][:server_root_password]}

execute "create SQL import lock" do
  user node[:catlady][:user]
  command "touch #{node[:catlady][:root]}/shared/.sql_done"
  action :nothing
end

execute "initial SQL import" do
  command "mysql --user=#{node[:catlady][:db][:username]} --password=#{node[:catlady][:db][:password]} --host=#{node[:catlady][:db][:hostname]} #{node[:catlady][:db][:name]} < #{node[:catlady][:root]}/current/catlady.mysql.sql"
  not_if { ::File.exists?("#{node[:catlady][:root]}/shared/.sql_done") }
  notifies :run, "execute[create SQL import lock]", :immediately
  action :nothing
end

execute "setup catlady extlib" do
  command "cpanm --notest --local-lib #{node[:catlady][:root]}/shared/extlib Module::Install local::lib"
  user node[:catlady][:user]
  environment({"PERL_CPANM_HOME" => "#{node[:catlady][:root]}/.cpanm"})
  not_if "perl -I#{node[:catlady][:root]}/shared/extlib/lib/perl5/ -Mlocal::lib=#{node[:catlady][:root]}/shared/extlib -mModule::Install -e ''"
end

execute "install catlady dependencies" do
  command "cpanm --notest --local-lib #{node[:catlady][:root]}/shared/extlib --installdeps #{node[:catlady][:root]}/current"
  user node[:catlady][:user]
  environment({"PERL_CPANM_HOME" => "#{node[:catlady][:root]}/.cpanm"})
end

deploy node[:catlady][:root] do
  user node[:catlady][:user]
  group node[:catlady][:user]
  not_if {::File.exists?("#{node[:catlady][:root]}/deploy.lock")}
  repository node[:catlady][:repo]
  revision node[:catlady][:revision]
  symlink_before_migrate "" => ""
  symlinks({ 
    "extlib" => "extlib",
    "etc" => "etc",
    "var" => "var"
  })
  create_dirs_before_symlink [ ]
  before_restart do
    link "#{node[:catlady][:root]}/current/share" do
      to "#{node[:alice][:root]}/current/share"
    end

    runit_service "catlady"
  end
  notifies :restart, "runit_service[catlady]"
end

mysql_database node[:catlady][:db][:name] do
  connection mysql_config
  action :create
end

mysql_database_user node[:catlady][:db][:username] do
  connection mysql_config
  password node[:catlady][:db][:password]
  database_name node[:catlady][:db][:name]
  privileges [:all]
  action :grant
  not_if { node[:catlady][:db][:username] == "root" }
  notifies :run, "execute[initial SQL import]", :immediately 
end

runit_service "catlady"
