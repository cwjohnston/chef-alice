maintainer "Cameron W Johnston"
maintainer_email "cwjohnston@gmail.com"
license "Apache 2.0"
description "Installs and configures Alice - an Altogether Lovely Internet Chatting Experience"
version "0.2.1"

%w{ build-essential git runit perl database varnish }.each do |cb|
  depends cb
end
