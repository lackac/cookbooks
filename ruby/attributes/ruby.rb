#
# Cookbook Name:: ruby
# attributes:: ruby_enterprise
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

set[:ruby_enterprise][:install_path]  = "/usr/local"
set[:ruby_enterprise][:ruby_bin]      = "/usr/local/bin/ruby"

set[:ruby][:install_path] = set[:ruby_enterprise][:install_path]
set[:ruby][:ruby_bin]     = set[:ruby_enterprise][:ruby_bin]
