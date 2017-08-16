#
# Cookbook Name:: dynamodb-local
# Recipe:: default
#
# Copyright (C) 2014 Timehop
#

package node["dynamodb-local"]["java_package"]

config = node["dynamodb-local"]

user config["user"] do
  comment 'Dynamo DB Local account'
end

directory config["directory"] do
  owner config["user"]
  group config["user"]
  action :create
end

tar_extract config["download_url"] do
  target_dir config["directory"]
  creates "#{config["directory"]}/DynamoDBLocal_lib"
end

template "/etc/systemd/system/dynamodb.service" do
  source "dynamodb.service.erb"
  mode 0644
  owner "root"
  variables(:directory => config["directory"])
end

service "dynamodb" do
    action [:enable, :restart]
  end
end