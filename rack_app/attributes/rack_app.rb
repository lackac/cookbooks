#
# Cookbook Name:: rack_app
# Attributes:: rack_app
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

# These are default values for any application. Use the :rack_apps attribute
# to set up your apps.
set_unless[:rack_apps] = {}

# Example rack app with most of the attributes set
#
# set[:rack_apps][:my_project] = {
#   :server_name => "example.com",
#   :server_aliases => ["www.example.com", "example.org"],
#   :deploy_to => "/srv/apps",
#   :repo => "git://github.com/me/project.git",
#   :branch => "stable",
#   :enable_submodules => true,
#   :environment => { 'RAILS_ENV'] => "production" },
#   :user => "app",
#   :group => "app",
#   :database => {
#     :type => "mysql",
#     :database => "project_prod",
#     :user => "project",
#     :password => "generate", # this would have it generated to a secure one
#     :host => "localhost"
#   },
#   :migration_command => "rake db:migrate",
#   :migrate => false,
#   :restart_command => "monit restart all -g app",
#   :action => "nothing" # deploy would happen by a configured chef-client call
# }
