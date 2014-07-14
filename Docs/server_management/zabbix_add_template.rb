#!/usr/bin/ruby
require "rubygems"
require "zabbixapi"

zbx = ZabbixApi.connect(
  :url => 'http://172.31.32.163/zabbix/api_jsonrpc.php',
  :user => 'admin',
  :password => 'zabbix'
)

zbx.templates.mass_add(
  :hosts_id => [zbx.hosts.get_id(:host => "ip-172-31-39-112")],
  :templates_id => [10001,10144]
)
