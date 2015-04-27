# alice
default[:alice][:repo] = "https://github.com/leedo/alice.git"
default[:alice][:revision] = "HEAD"
default[:alice][:root] = "/opt/alice"
default[:alice][:logdir] = '/var/log/alice'
default[:alice][:ip] = "0.0.0.0"
default[:alice][:port] = "8000"
default[:alice][:user] = "alice"
default[:alice][:require_auth] = false
default[:alice][:run_standalone] = true
