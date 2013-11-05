#
# Cookbook Name:: Misfit-Newrelic-plugins
# ###########################################
# Copyright 2013, Binh Nguyen
#############################################
# All rights reserved  under MIT license.
#
# Follow the installation guide from Newrelic Plugin Agent at:
#   https://pypi.python.org/pypi/newrelic_plugin_agent
# 


include_recipe "python::pip"
p "Aaaaaaaaaaaaaaaaaaaa:  #{node["newrelic"]["license_key"]}"
if node["newrelic"]["license_key"].nil?
  
  Chef::Log.debug("^^^ Could not install these plugins. Please put your Newrelic license key in the run-list.")
  
else
  
  group node["newrelic"]["group"]  do
    action :create
  end

  user node["newrelic"]["user"] do
    gid node["newrelic"]["group"]
    action :create
  end

  directory node["newrelic"]["run_dir"] do
    owner node["newrelic"]["user"]
    group node["newrelic"]["group"]
    mode  '755'
  end

  directory node["newrelic"]["log_dir"] do
    owner node["newrelic"]["user"]
    group node["newrelic"]["group"]
    mode  '700'
  end

  directory node["newrelic"]["config_dir"] do
    owner node["newrelic"]["user"]
    group node["newrelic"]["group"]
    mode  '700'
  end

  # install newrelic-plugin-agent
  python_pip 'newrelic-plugin-agent' do
    action :install
  end


  template node["newrelic"]["config_file"] do
  	source "newrelic_plugin_agent.cfg.erb"
  	owner node["newrelic"]["user"]
  	group node["newrelic"]["group"]
  	mode "0600"
  	variables({
  		:hostname => node["hostname"],
  		:license_key => node["newrelic"]["license_key"],
  		:poll_interval => node["newrelic"]["poll_interval"],
  		:user => node["newrelic"]["user"],
  		:pid_file => node["newrelic"]["pid_file"],
  		:log_file => node["newrelic"]["log_file"],
  		:mongodb => node["newrelic"]["mongodb"],
      :memcached_name => node["newrelic"]["memcached"]["memcached_name"],
      :memcached_host => node["newrelic"]["memcached"]["memcached_host"],
      :memcached_port => node["newrelic"]["memcached"]["memcached_port"],
      :redis_name => node["newrelic"]["redis"]["redis_name"],
      :redis_host => node["newrelic"]["redis"]["redis_host"],
      :redis_port => node["newrelic"]["redis"]["redis_port"],
  		:nginx => node["newrelic"]["nginx"],
  		:postgresql => node["newrelic"]["postgresql"],
  		:redis => node["newrelic"]["redis"]
  	})
  end

  bash "Install the Newrelic plugin agents to this instance" do
    user "root"
    cwd "/"
    code <<-EOH
    sudo newrelic_plugin_agent -c /etc/newrelic/newrelic_plugin_agent.cfg
    EOH
  end

  bash "Install the Newrelic server plugin to this instance" do
    user "root"
    cwd "/"
    code <<-EOH
    sudo wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list
    sudo apt-key adv --keyserver hkp://subkeys.pgp.net --recv-keys 548C16BF
    sudo apt-get update
    sudo apt-get install newrelic-sysmond
    sudo nrsysmond-config --set license_key=#{node["newrelic"]["license_key"]}
    sudo /etc/init.d/newrelic-sysmond start
    EOH
  end

end

