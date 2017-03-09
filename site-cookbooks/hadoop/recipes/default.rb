#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{openssh-server openssh-clients}.each do |pkg|
    package pkg do
        action :upgrade
    end
end

service "sshd" do
    supports :status => true, :restart => true
    action [ :enable, :start ]
end

bash "ssh_setting" do
    user 'root'
    group 'root'
    code <<-EOF
        ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
        cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    EOF
end

bash "hadoop_install" do
    user 'root'
    group 'root'
    code <<-EOF
        curl -L http://apache.tt.co.kr/hadoop/common/hadoop-#{node['hadoop']['version']}/hadoop-#{node['hadoop']['version']}.tar.gz | tar -xz -C /usr/local/
        cd /usr/local && ln -s ./hadoop-#{node['hadoop']['version']} hadoop
        cd /usr/local/hadoop && mkdir -p logs
    EOF
end
