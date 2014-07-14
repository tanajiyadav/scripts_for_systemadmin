#!/usr/bin/ruby
require "rubygems"
require "zabbixapi"

zabbix_server = "http://zabbixeast.wfxtriggers.com/zabbix/api_jsonrpc.php"
group = "TWS-AMS-Appnexus"

####################################
File.readlines("zabbixhosts_eu").each {|host|
list = host.split()
hostname=list[0]
dns=list[1]
ip=list[1]

zbx = ZabbixApi.connect(
  :url => "#{zabbix_server}",
  :user => 'tanaji.yadav@weather.com',
  :password => '@password1.0'
)

zbx.hosts.create(
  :host => "#{hostname}",
  :interfaces => [
    {
      :type => 1,
      :main => 1,
      :ip => "#{ip}",
      :dns => "#{dns}",
      :port => 10050,
      :useip => 1
    }
  ],
  :groups => [ :groupid => zbx.hostgroups.get_id(:name => "#{group}") ]
)
zbx.templates.mass_add(
  :hosts_id => [zbx.hosts.get_id(:host => "#{hostname}")],
  :templates_id => [10001,10109,10155,10188]
)
}
#10001,10125,10129,10167
