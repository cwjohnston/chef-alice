maintainer "Cameron W Johnston"
maintainer_email "cwjohnston@gmail.com"
license "Apache 2.0"
description "Installs and configures Alice - an Altogether Lovely Internet Chatting Experience"
version "0.1.0"

%w{ build-essential git runit perl database }.each do |cb|
  depends cb
end
