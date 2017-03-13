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
    not_if { File.exists?("/root/.ssh/authorized_keys") }
    code <<-EOF
        ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
        cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    EOF
end

bash "hadoop_install" do
    not_if { File.exists?("/usr/local/hadoop") }

    user 'root'
    group 'root'
    code <<-EOF
        curl -L  http://apache.tt.co.kr/hadoop/common/hadoop-#{node['hadoop']['version']}/hadoop-#{node['hadoop']['version']}.tar.gz | tar -xz -C /usr/local/
        cd /usr/local && ln -s ./hadoop-#{node['hadoop']['version']} hadoop
        cd /usr/local/hadoop && mkdir -p logs


        echo -e "export HADOOP_HOME=/usr/local/hadoop" >> /etc/profile
        echo -e "export HADOOP_PREFIX=/usr/local/hadoop" >> /etc/profile
        echo -e "export HADOOP_COMMON_HOME=/usr/local/hadoop" >> /etc/profile
        echo -e "export HADOOP_YARN_HOME=/usr/local/hadoop" >> /etc/profile
        echo -e "export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop" >> /etc/profile
        echo -e "export YARN_CONF_DIR=/usr/local/hadoop/etc/hadoop" >> /etc/profile

        echo -e "export PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin" >> /etc/profile

        source /etc/profile
    EOF
end

%w{core-site.xml hadoop-env.sh hdfs-site.xml mapred-site.xml yarn-site.xml}.each do |tmp|
    template tmp do
        path "/usr/local/hadoop/etc/hadoop/#{tmp}"
        source "#{tmp}.erb"
        owner "root"
        group "root"
    end
end
