define :catlady_config do

  default_server = {
    :name => "alice",
    :host => "irc.usealice.org",
    :port => 6767,
    :channels => ["#alice"]
  }

  config = {
    :port => node[:catlady][:port],
    :address => node[:catlady][:ip],
    :salt => node[:catlady][:salt],
    :secret => node[:catlady][:secret],
    :domain => node[:catlady][:domain],
    :cookie => node[:catlady][:cookie],
    :db_user => node[:catlady][:db][:username],
    :db_pass => node[:catlady][:db][:password],
    :configs => node[:catlady][:user_config_dir],
    :shell_sock => node[:catlady][:socket],
    :sharedir => node[:catlady][:sharedir],
    :dsn => "DBI:mysql:dbname=#{node[:catlady][:db][:name]};host=#{node[:catlady][:db][:hostname]};port=#{node[:catlady][:db][:port]};mysql_auto_reconnect=1;mysql_enable_utf8=1",
    :db_attr => node[:catlady][:db][:params].to_hash,
    :default_server => node[:catlady][:default_server].to_hash,
    :static_prefix => "/static/",
    :image_prefix => ""
  }

  json_file params[:name] do
    content config
    mode 0644
  end
  
end
