#!/usr/bin/ruby
require "rubygems"
require "zabbixapi"

zbx = ZabbixApi.connect(
  :url => 'http://zabbix/zabbix/api_jsonrpc.php',
  :user => 'a',
  :password => '9'
)

print zbx.templates.get_ids_by_host( :hostids => [zbx.hosts.get_id(:host => "Prod_TWS_NY_Bidder_1")] )
