#
# Cookbook Name:: rack_app
# Recipe:: default
#
# Author:: László Bácsi (<lackac@icanscale.com>)
# Based on the rails_app cookbook taken from
#   http://github.com/nbudin/chef-repo/tree/master/cookbooks/rails_app/
#
# Copyright 2010, László Bácsi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

gem_package "bundler" do
  version "0.8"
  action :install
end

node[:rack_apps].each do |name, properties|
  rack_app name do
    (properties.nil? ? node[name] : properties).each do |k, v|
      send(k, v)
    end
  end
end

nginx_site "000-default" do
  enable false
end
