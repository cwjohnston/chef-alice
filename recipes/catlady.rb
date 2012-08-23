include_recipe "alice::default"
include_recipe "database"

user node[:catlady][:user] do
  system true
end

runit_service "catlady"

service "catlady" do
  supports :status => true, :restart => true
end

%w{ etc/users var }.each do |dir|
  directory "#{node[:catlady][:root]}/shared/#{dir}" do
    recursive true
  end
end

link "#{node[:catlady][:root]}/shared/extlib" do
  to "#{node[:alice][:root]}/shared/extlib"
end

catlady_config "#{node[:catlady][:root]}/shared/etc/config.json"

mysql_config = {:host => node[:catlady][:db][:hostname], :username => 'root', :password => node[:mysql][:server_root_password]}

mysql_import = execute "initial SQL import" do
  command "mysql --user=#{node[:catlady][:db][:username]} --password=#{node[:catlady][:db][:password]} --host=#{node[:catlady][:db][:hostname]} #{node[:catlady][:db][:name]} < #{node[:catlady][:root]}/current/catlady.sql"
  action :nothing
end

%w{ FindBin
    Digest::SHA1
    Digest::HMAC_SHA1
    Plack::Middleware::ReverseProxy
    Plack::Session
    Any::Moose
    AnyEvent
    AnyEvent::DBI::Abstract
    List::Util
    Path::Class
    Text::MicroTemplate::File
    FindBin }.each do |pl|
      execute "install dependency #{pl}" do
        command "cpanm --notest --local-lib #{node[:catlady][:root]}/shared/extlib #{pl}"
        not_if "perl -I#{node[:catlady][:root]}/shared/extlib/lib/perl5/ -Mlocal::lib=#{node[:catlady][:root]}/shared/extlib -m#{pl} -e ''"
      end
    end

deploy node[:catlady][:root] do
  not_if {File.exists?("#{node[:catlady][:root]}/deploy.lock")}
  repo node[:catlady][:repo]
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
  end
end

mysql_database node[:catlady][:db][:name] do
  connection mysql_config
  action :create
end

mysql_database_user node[:catlady][:db][:username] do
  connection mysql_config
  password node[:catlady][:db][:password]
  database_name node[:catlady][:db][:name]
  privileges [:select,:update,:insert]
  action :grant
  not_if { node[:catlady][:db][:username] == "root" }
end

mysql_import.run_action(:run)
