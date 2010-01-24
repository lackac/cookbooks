maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Helper library to determine whether distribution-only packages are installed and to install/remove extra packages"
version           "0.9"

%w{redhat centos}.each do |os|
  supports os
end

attribute "packages",
  :display_name => "Packages",
  :description => "Hash of Packages attributes",
  :type => "hash"

attribute "packages/dist_only",
  :display_name => "Packages Distribution Only?",
  :description => "Set to only use distribution-provided packages",
  :default => "false"

attribute "packages/packages",
  :display_name => "Extra packages to install/remove",
  :description => "Hash of packages in form of 'package_name' => {attributes}",
  :type => "hash"
