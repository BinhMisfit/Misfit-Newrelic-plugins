default["newrelic"]["user"]      = "newrelic"
default["newrelic"]["group"]     = "newrelic"
default["newrelic"]["license_key"] = nil # put your license key here!
default["newrelic"]["home"]      = "/usr/share/newrelic"
default["newrelic"]["run_dir"]   = "/var/run/newrelic"
default["newrelic"]["log_dir"]   = "/var/log/newrelic"
default["newrelic"]["config_dir"]   = "/etc/newrelic"

default["newrelic"]["poll_interval"] = 60
default["newrelic"]["pid_file"] = "#{newrelic["run_dir"]}/newrelic_plugin_agent.pid"
default["newrelic"]["log_file"] = "#{newrelic["log_dir"]}/newrelic_plugin_agent.log"
default["newrelic"]["config_file"] = "#{newrelic["config_dir"]}/newrelic_plugin_agent.cfg"


########################################### memcached plugins

default["newrelic"]["memcached"]["memcached_name"] = "localhost"
default["newrelic"]["memcached"]["memcached_host"] = "127.0.0.1"
default["newrelic"]["memcached"]["memcached_port"] = 11211