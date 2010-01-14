define :rails_app, :deploy => true do
  include_recipe "rails_app"

  shared_dirs = %w{config log pids system}

  case params[:db][:type]
  when "sqlite"
    include_recipe "sqlite"
    gem_package "sqlite3-ruby"
    shared_dirs << "sqlite"
  when "mysql"
    include_recipe "mysql::client"
  end
  include_recipe "passenger::nginx"

  shared_dirs.each do |dir|
    directory "/srv/#{params[:name]}/shared/#{dir}" do
      recursive true
      owner params[:user]
      group params[:group]
      mode "0775"
    end
  end

  root_dir = "/srv/#{params[:name]}"
  database_server = params[:db][:server] || "localhost"
  server_name = params[:server_name].to_a.join(" ")
  server_aliases = params[:server_aliases].to_a.join(" ")

  template "#{root_dir}/shared/config/database.yml" do
    source "database.yml.erb"
    owner params[:user]
    group params[:group]
    variables :params => params
    mode "0664"
  end

  if params[:db][:type] == "mysql" and (params[:db][:server].blank? or params[:db][:server] == "localhost")
    database params[:db][:database] do
      user params[:db][:user]
      password params[:db][:password]
    end
  end

  if params[:db][:type] =~ /sqlite/
    file "#{root_dir}/shared/sqlite/production.sqlite3" do
      owner params[:user]
      group params[:group]
      mode "0664"
    end
  end


  deploy root_dir do
    case params[:scm_provider]
    when :subversion, :svn
      scm_provider Chef::Provider::Subversion
    else
      scm_provider Chef::Provider::Git
    end
    repo params[:repo]
    branch params[:branch]
    user params[:user]
    group params[:group]
    enable_submodules false
    migrate params[:migrate]
    migration_command params[:migrate_command]
    environment params[:environment]
    shallow_clone true
    revision params[:revision]
    action (params[:action] || :nothing).to_sym
    restart_command "touch tmp/restart.txt"
  end

  template "#{node[:nginx][:conf_dir]}/sites-available/#{params[:name]}.conf" do
    source "rails_app.conf.erb"
    owner "root"
    group "root"
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :root_dir => root_dir,
      :server_name => server_name,
      :server_aliases => server_aliases,
      :params => params
    )
    if File.exists?("#{node[:nginx][:conf_dir]}/sites-enabled/#{params[:name]}.conf")
      notifies :reload, resources(:service => "nginx"), :delayed
    end
  end

  nginx_site "#{params[:name]}.conf" do
    enable enable_setting
  end
end
