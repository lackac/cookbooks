maintainer       "László Bácsi"
maintainer_email "lackac@icanscale.com"
license          "Apache 2.0"
description      "Installs and configures Passenger with nginx"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w{ ruby nginx }.each do |cb|
  depends cb
end

supports "ubuntu"
