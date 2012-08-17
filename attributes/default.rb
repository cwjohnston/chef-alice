# alice
default[:alice][:repo] = "https://github.com/leedo/alice.git"
default[:alice][:revision] = "HEAD"
default[:alice][:root] = "/opt/alice"
default[:alice][:ip] = "0.0.0.0"
default[:alice][:port] = "8000"
default[:alice][:require_auth] = false
# catlady
default[:catlady][:require_auth] = false
default[:catlady][:repo] = "https://github.com/leedo/catlady.git"
default[:catlady][:revision] = "HEAD"
default[:catlady][:root] = "/opt/catlady"
default[:catlady][:ip] = "0.0.0.0"
default[:catlady][:port] = "9000"