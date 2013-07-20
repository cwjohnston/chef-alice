include_recipe "varnish"

template "/etc/varnish/alice.vcl" do
  source "alice.vcl.erb"
  mode '0644'
  notifies :restart, "service[varnish]"
end
