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
