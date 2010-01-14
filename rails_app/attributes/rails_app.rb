#
# Cookbook Name:: rails_app
# Attributes:: rails_app
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

set_unless[:rails][:version] = false

set_unless[:rails_app][:revision]         = "HEAD"
set_unless[:rails_app][:branch]           = "HEAD"
set_unless[:rails_app][:environment]      = "production"
set_unless[:rails_app][:user]             = "www-data"
set_unless[:rails_app][:group]            = "www-data"
set_unless[:rails_app][:migrate_command]  = "rake #{rails_app[:environment]} db:migrate"
set_unless[:rails_app][:migrate]          = false
set_unless[:rails_app][:action]           = "nothing"
set_unless[:rails_app][:scm_provider]     = :git
