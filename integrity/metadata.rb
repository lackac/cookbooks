maintainer        "László Bácsi"
maintainer_email  "lackac@icanscale.com"
description       "Configures integrity as an nginx passenger application"
version           "0.1"

%w{ database sqlite mysql nginx passenger }.each do |cb|
  depends cb
end
