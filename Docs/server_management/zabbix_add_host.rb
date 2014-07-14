#!/usr/bin/ruby
require "rubygems"
require "zabbixapi"

zabbix_server = "http://54.186.146.58/zabbix/api_jsonrpc.php"
group = "TWS Servers"

####################################
IO.foreach("zabbixhosts"){|host|
host.gsub!(/\n/, "") 
#host = "ip-172-31-23-247"
ip = host.gsub(/ip-/, "")
ip = ip.gsub!(/-/, ".")
zbx = ZabbixApi.connect(
  :url => "#{zabbix_server}",
  :user => 'admin',
  :password => 'zabbix'
)

zbx.hosts.create(
  :host => "#{host}",
  :interfaces => [
    {
      :type => 1,
      :main => 1,
      :ip => "#{ip}",
      :dns => "#{host}.ec2.internal",
      :port => 10050,
      :useip => 1
    }
  ],
  :groups => [ :groupid => zbx.hostgroups.get_id(:name => "#{group}") ]
)
zbx.templates.mass_add(
  :hosts_id => [zbx.hosts.get_id(:host => "#{host}")],
  :templates_id => [10001,10144]
)
}
