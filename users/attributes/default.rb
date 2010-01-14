users Mash.new unless attribute?("users")
groups Mash.new unless attribute?("groups")
ssh_keys Mash.new unless attribute?("ssh_keys")

groups[:app]   = {:gid => 5000}
groups[:site]  = {:gid => 6000}
groups[:admin] = {:gid => 7000}

# passwords must be in shadow password format with a salt. To generate: openssl passwd -1

#users[:jose] = {:password => "shadowpass", :comment => "José Amador", :uid => 4001, :group => :admin}

#ssh_keys[:jose] = "ssh-rsa keydata"
