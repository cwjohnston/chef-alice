include_recipe "alice::default"

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

default_server = {
    :name => "alice",
    :host => "irc.usealice.org",
    :port => 6767,
    :channels => ["#alice"]
  }

config = {
  :port => node[:catlady][:port],
  :address => node[:catlady][:address],
  :salt => node[:catlady][:salt],
  :secret => node[:catlady][:secret],
  :domain => node[:catlady][:domain],
  :cookie => node[:catlady][:cookie],
  :db_user => node[:catlady][:db][:username],
  :db_pass => node[:catlady][:db][:password],
  :dsn => "DBI:mysql:dbname=#{node[:catlady][:db][:name]};host=#{node[:catlady][:db][:hostname]};port=#{node[:catlady][:db][:port]};mysql_auto_reconnect=1;mysql_enable_utf8=1",
  :db_attr => { },
  :default_server => default_server,
  :static_prefix => "/static/",
  :image_prefix => ""
}

json_file "#{node[:catlady][:root]}/shared/etc/config.json" do
  content config
  owner "root"
  group "root"
  mode "0644"
end

%w{ FindBin
    Digest::SHA1
    Digest::HMAC_SHA1
    Plack::Middleware::Session
    Plack::Middleware::ReverseProxy
    Plack::Session::Store::Cache
    Plack::Session::State::Cookie
    Any::Moose
    AnyEvent::Strict
    AnyEvent::Socket
    AnyEvent::Handle
    AnyEvent::DBI::Abstract
    List::Util
    Path::Class
    Text::MicroTemplate::File
    FindBin
    Any::Moose
    MouseX::Getopt }.each do |pl|
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