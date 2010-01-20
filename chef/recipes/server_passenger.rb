#
# Author:: László Bácsi <lackac@icanscale.com>
# Cookbook Name:: chef
# Recipe:: server_passenger
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

include_recipe "runit"
include_recipe "couchdb"
include_recipe "stompserver"
include_recipe "passenger::nginx"

group "chef" do
  gid 8000
end

user "chef" do
  comment "Chef user"
  gid "chef"
  uid 8000
  home node[:chef][:path]
  supports :manage_home => false
  shell "/bin/bash"
end

include_recipe "chef::client"

gem_package "chef-server" do
  version node[:chef][:server_version]
end

gem_package "chef-server-slice" do
  version node[:chef][:server_version]
end

runit_service "chef-indexer"

template "/etc/chef/server.rb" do
  source "server_passenger.rb.erb"
  owner "chef"
  group "chef"
  mode "644"
  notifies :restart, resources(
    :service => "chef-indexer"
  ), :delayed
end

directory "/var/log/chef" do
  owner "chef"
  group "chef"
  mode "775"
end

%w{openid cache search_index openid/cstore}.each do |dir|
  directory "#{node[:chef][:path]}/#{dir}" do
    owner "chef"
    group "chef"
    mode "775"
    recursive true
  end
end

directory "/etc/chef/certificates" do
  owner "chef"
  group "chef"
  mode 0700
  recursive true
end

bash "Create SSL Certificates" do
  cwd "/etc/chef/certificates"
  code <<-EOH
umask 077
openssl genrsa 2048 > #{node[:chef][:server_fqdn]}.key
openssl req -subj "#{node[:chef][:server_ssl_req]}" -new -x509 -nodes -sha1 -days 3650 -key #{node[:chef][:server_fqdn]}.key > #{node[:chef][:server_fqdn]}.crt
cat #{node[:chef][:server_fqdn]}.key #{node[:chef][:server_fqdn]}.crt > #{node[:chef][:server_fqdn]}.pem
EOH
  not_if { File.exists?("/etc/chef/certificates/#{node[:chef][:server_fqdn]}.pem") }
end

template "#{node[:nginx][:dir]}/sites-available/chef_server.conf" do
  source "chef_server_passenger.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables :gems_path => node[:languages][:ruby][:gems_dir],
            :version => node[:chef][:server_version]
  if File.exists?("#{node[:nginx][:dir]}/sites-enabled/chef_server.conf")
    notifies :restart, resources(:service => "nginx"), :delayed
  end
end

nginx_site "chef_server.conf" do
  enable enable_setting
  only_if { File.exists?("#{node[:nginx][:dir]}/sites-available/chef_server.conf") }
end

http_request "compact chef couchDB" do
  action :post
  url "http://localhost:5984/chef/_compact"
  only_if do
    begin
      open("#{Chef::Config[:couchdb_url]}/chef")
      JSON::parse(open("#{Chef::Config[:couchdb_url]}/chef").read)["disk_size"] > 100_000_000
    rescue OpenURI::HTTPError
      nil
    end
  end
end
