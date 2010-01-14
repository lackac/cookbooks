maintainer        "László Bácsi"
maintainer_email  "lackac@icanscale.com"
license           "Apache 2.0"
description       "Deploys a rails app with chef-deploy and nginx"
version           "0.1"

supports "ubuntu"

depends "database"
depends "passenger::nginx"
