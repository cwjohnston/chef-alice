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
    execute "setup catlady extlib" do
      command "cpanm --notest --local-lib #{node[:catlady][:root]}/shared/extlib Module::Install local::lib"
    end

    %w{ FindBin
      Digest::SHA1
      Plack::Middleware::Session
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
      Any::Moose }.each do |dep|
        execute "install #{dep}" do
          command "cpanm --notest --local-lib #{node[:catlady][:root]}/shared/extlib #{dep}"
        end
      end
  end 
end