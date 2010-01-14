#
# Cookbook Name:: passenger
# Based on passenger_enterprise from opscode
# attributes:: passenger
#
# Author:: László Bácsi (<lackac@icanscale.com>)
#
# Copyright:: 2010, László Bácsi
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
set_unless[:passenger][:version]      = "2.2.9"
set_unless[:passenger][:root_path]    = "/usr/local/lib/ruby/gems/1.8/gems/passenger-#{passenger[:version]}"
