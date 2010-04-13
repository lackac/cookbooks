#
# Cookbook Name:: integrity
# Recipe:: default
#
# Author:: László Bácsi (<lackac@icanscale.com>)
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

%w{log pids vendor}.each do |dir|
  directory "#{node[:integrity][:path]}/shared/#{dir}" do
    recursive true
    owner node[:integrity][:user]
    group node[:integrity][:group]
    mode "0775"
  end
end

directory node[:integrity][:export_dir] do
  recursive true
  owner node[:integrity][:user]
  group node[:integrity][:group]
  mode "0775"
end

symlink_from_shared = { "log" => "log", "pids" => "tmp/pids" }

if node[:integrity][:database_uri] =~ /^sqlite3:(.*)$/
  db_path = $1
  include_recipe "sqlite"
  file "#{node[:integrity][:path]}/shared/#{db_path}" do
    owner node[:integrity][:user]
    group node[:integrity][:group]
    mode "0664"
  end
  symlink_from_shared[db_path] = db_path
elsif node[:integrity][:database_uri] =~ /^mysql:\/\/(.*?):(.*?)@localhost\/(.*)$/
  user, pass, db = $~.captures
  include_recipe "mysql"
  database db do
    provider Chef::Provider::DatabaseMysql
    user user
    password pass
    action :create
  end
end

deploy_branch node[:integrity][:path] do
  repo          node[:integrity][:repo]
  branch        node[:integrity][:branch]
  user          node[:integrity][:user]
  group         node[:integrity][:group]
  environment   "RACK_ENV" => "production"

  migrate           true
  migration_command "rake db"

  purge_before_symlink        %w{log tmp/pids}
  create_dirs_before_symlink  %w{tmp public}
  symlink_before_migrate({})
  symlinks                    symlink_from_shared

  before_migrate do
    current_release = release_path
    deploy_node = node
    deploy_resource = new_resource

    template "#{current_release}/init.rb" do
      source "init.rb.erb"
      mode "0644"
    end

    remote_file "#{current_release}/excluding_auth.rb" do
      source "excluding_auth.rb"
      mode "0644"
    end

    template "#{current_release}/config.ru" do
      source "config.ru.erb"
      mode "0644"
    end

    ruby_block "modify_integrity_gemfile" do
      block do
        notifiers = deploy_node[:integrity][:notifiers]
        re = %r{(# = (?:#{notifiers.join("|")}))\s*((?:# gem [^\n]*\n)+)}i
        gemfile = File.read("#{current_release}/Gemfile")
        gemfile.gsub!(re) { "#{$1}\n#{$2.gsub(/^# /, '')}" }
        File.open("#{current_release}/Gemfile", "w") do |f|
          f.write(gemfile)
        end
      end
    end

    execute "bundle_integrity_gems" do
      command "cd #{current_release} && bundle install"
    end
  end
end

template "#{node[:nginx][:dir]}/sites-available/integrity.conf" do
  source "integrity.conf.erb"
  owner "root"
  group "root"
  mode 0644
  if File.exists?("#{node[:nginx][:dir]}/sites-enabled/integrity.conf")
    notifies :restart, resources(:service => "nginx"), :delayed
  end
end

nginx_site "integrity.conf" do
  enable enable_setting
end
