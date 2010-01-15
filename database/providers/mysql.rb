action :create do
  execute "create database" do
    not_if "mysql -e 'SHOW DATABASES;' | grep #{new_resource.name}"
    command "mysql -e 'CREATE DATABASE #{new_resource.name}';"
  end
  if new_resource.user
    execute "create user and grant privileges to the database" do
      host = new_resource.host || "localhost"
      password = " IDENTIFIED BY '#{new_resource.password}'" if new_resource.password
      command %(mysql -e "GRANT ALL ON #{new_resource.name}.* TO '#{new_resource.user}'@'#{host}'#{password};")
    end
  end
end

action :delete do
  execute "delete database" do
    only_if "mysql -e 'SHOW DATABASES;' | grep #{new_resource.name}"
    command "mysql -e 'DROP DATABASE #{new_resource.name}';"
  end
  if new_resource.user
    execute "drop user" do
      command "mysql -e 'DROP USER #{new_resource.user};'"
    end
  end
end
