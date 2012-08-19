# Alice + Chef == automatic hardchats
This cookbook installs and configures a single-user instance of [Alice](https://github.com/leedo/alice).

## The live version

* `bundle install`
* `bundle exec rake install_deps`
* `bundle exec vagrant up`
* visit [http://172.16.20.125:8000](http://172.16.20.125:8000) in your browser

## Multiplayer mode with `catlady`

* generate a password hash:
`perl -MDigest::SHA1=sha1_hex -E 'say sha1_hex("password-salt")'`
make sure `node[:catlady][:salt]` matches the salt used above.
* add yourself a user to the mysql database running on localhost (root password is `changeme`)
* log in at [http://172.16.20.125:9000](http://172.16.20.125:9000) 


