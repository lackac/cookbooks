#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright 2009, Opscode, Inc
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

r = gem_package "chef-deploy" do
  source "http://gems.engineyard.com"
  action :nothing
end

r.run_action(:install)

Gem.clear_paths
require "chef-deploy"

node[:rails_apps].each do |name, properties|
  rails_app name do
    properties.each do |k, v|
      send(k, v)
    end
  end
end

nginx_site "000-default" do
  enable false
end
