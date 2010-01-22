#
# Cookbook Name:: integrity
# Attributes:: integrity
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

set_unless[:integrity][:path]         = "/srv/integrity"
set_unless[:integrity][:server_name]  = domain ? "ci.#{domain}" : "ci"
set_unless[:integrity][:repo]         = "git://github.com/integrity/integrity"
set_unless[:integrity][:branch]       = "master"
set_unless[:integrity][:user]         = "integrity"
set_unless[:integrity][:group]        = "app"

set_unless[:integrity][:database_uri] = "sqlite3:integrity.db"
set_unless[:integrity][:export_dir]   = "#{integrity[:path]}/shared/builds"
set_unless[:integrity][:log_file]     = "#{integrity[:path]}/shared/log/integrity.log"

set_unless[:integrity][:basic_auth]   = true
set_unless[:integrity][:auth_user]    = "integrity"
set_unless[:integrity][:auth_pass]    = "RunCodeRun"
set_unless[:integrity][:protect_all]  = false
set_unless[:integrity][:github_token] = "runC0d3Run"

set_unless[:integrity][:build_all]    = false
set_unless[:integrity][:notifiers]    = [:email, :campfire]
