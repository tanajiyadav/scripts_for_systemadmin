#!/usr/bin/ruby
require "rubygems"
require "zabbixapi"

zabbix_server = "http://54/zabbix/api_jsonrpc.php"
group = "EU_TWS_SERVERS"

####################################
File.readlines("zabbixhosts_eu").each {|host|
list = host.split()
hostname=list[0]
dns=list[1]
ip=list[1].gsub(/ec2-/,"")
ip=ip.gsub!(/-/, ".")
ip=ip.gsub!(/.eu.west.1.compute.amazonaws.com/, "")

zbx = ZabbixApi.connect(
  :url => "#{zabbix_server}",
  :user => 't',
  :password => '@'
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
  :templates_id => [10001,10155,10156,10158,10162,10178]
)
}
