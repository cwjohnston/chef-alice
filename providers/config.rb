action :create do

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
    :configs => node[:catlady][:configs],
    :shell_sock => node[:catlady][:socket],
    :sharedir => node[:catlady][:sharedir],
    :dsn => "DBI:mysql:dbname=#{node[:catlady][:db][:name]};host=#{node[:catlady][:db][:hostname]};port=#{node[:catlady][:db][:port]};mysql_auto_reconnect=1;mysql_enable_utf8=1",
    :db_attr => { },
    :default_server => default_server,
    :static_prefix => "/static/",
    :image_prefix => ""
  }

  config_resource = @new_resource
  json_file @new_resource.name do
    content config
    mode 0644
    notifies :updated, config_resource
  end
end

action :updated do
  @new_resource.updated_by_last_action(true)
end
