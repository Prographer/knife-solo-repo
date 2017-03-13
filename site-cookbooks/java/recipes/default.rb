#
# Cookbook Name:: java
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "curl" do
    action :upgrade
end

bash "java_install" do
    not_if "rpm -qa | grep #{node['java']['rpm']['name']}"

    user 'root'
    group 'root'
    code <<-EOF
        curl -LO 'http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/#{node['java']['rpm']['file']}.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
        rpm -i #{node['java']['rpm']['file']}.rpm
        rm #{node['java']['rpm']['file']}.rpm

        echo -e "export JAVA_HOME=/usr/java/default" >> /etc/profile
        echo -e "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile

        rm /usr/bin/java && ln -s /usr/java/default/bin/java /usr/bin/java
    EOF

end
