#
# Cookbook Name:: rack_app
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

default_params = {
  :environment => {
    'RAILS_ENV' => "production",
    'RACK_ENV'  => "production",
    'MERB_ENV'  => "production"
  },
  :user               => "www-data",
  :group              => "www-data",
  :migration_command  => "rake db:migrate",
  :restart_command    => "touch tmp/restart.txt",
  :action             => "nothing"
}

define :rack_app, default_params do
  name = params.delete(:name)
  root_dir = "/srv/#{name}"
  db = params.delete(:database)
  db[:host] ||= "localhost"
  server_name = params.delete(:server_name).to_a.join(" ")
  server_aliases = params.delete(:server_aliases).to_a.join(" ")
  shared_dirs = %w{config log pids system}
  environment = params[:environment][params[:environment].keys.first]

  case db[:type]
  when "sqlite"
    include_recipe "sqlite"
    gem_package "sqlite3-ruby"
    shared_dirs << "sqlite"
  when "mysql"
    include_recipe "mysql::client"
  end
  include_recipe "passenger::nginx"

  shared_dirs.each do |dir|
    directory "/srv/#{name}/shared/#{dir}" do
      recursive true
      owner params[:user]
      group params[:group]
      mode "0775"
    end
  end

  if db[:password] == "generate"
    db[:password] = secure_password
  end

  template "#{root_dir}/shared/config/database.yml" do
    source "database.yml.erb"
    owner params[:user]
    group params[:group]
    variables :database => db, :environment => environment
    mode "0664"
  end

  if db[:type] == "mysql" and (db[:host].blank? or db[:host] == "localhost")
    database db[:database] do
      provider Chef::Provider::DatabaseMysql
      user db[:user]
      password db[:password]
      action :create
    end
  end

  if db[:type] =~ /sqlite/
    file "#{root_dir}/shared/sqlite/#{environment}.sqlite3" do
      owner params[:user]
      group params[:group]
      mode "0664"
    end
  end

  deploy root_dir do
    params.each do |key, value|
      case key.to_sym
      when :scm_provider
        case value.to_sym
        when :subversion, :svn
          scm_provider Chef::Provider::Subversion
        else
          scm_provider Chef::Provider::Git
        end
      else
        send key, value
      end
    end
  end

  template "#{node[:nginx][:dir]}/sites-available/#{name}.conf" do
    source "rack_app.conf.erb"
    owner "root"
    group "root"
    mode 0644
    variables :name => name, :root_dir => root_dir,
              :server_name => server_name, :server_aliases => server_aliases
    if File.exists?("#{node[:nginx][:dir]}/sites-enabled/#{name}.conf")
      notifies :restart, resources(:service => "nginx"), :delayed
    end
  end

  nginx_site "#{name}.conf" do
    enable enable_setting
  end
end
