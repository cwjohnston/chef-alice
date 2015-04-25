name "alice"
maintainer "Cameron W Johnston"
maintainer_email "cwjohnston@gmail.com"
license "Apache 2.0"
description "Installs and configures Alice - an Altogether Lovely Internet Chatting Experience"
version "0.3.5"


depends 'build-essential'
depends 'git'
depends 'perl'
depends 'database', '~> 4.0'
depends 'varnish', '~> 2.1'
depends 'runit', '~> 1.1'
