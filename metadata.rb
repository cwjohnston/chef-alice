name "alice"
maintainer "Cameron W Johnston"
maintainer_email "cwjohnston@gmail.com"
license "Apache 2.0"
description "Installs and configures Alice - an Altogether Lovely Internet Chatting Experience"
version "0.3.3"

%w{ build-essential git perl database varnish }.each do |cb|
  depends cb
end

depends 'runit', '~> 1.1.6'
