#!/usr/bin/ruby
require "rubygems"
require "zabbixapi"

zbx = ZabbixApi.connect(
  :url => 'http://zabbixeast.wfxtriggers.com/zabbix/api_jsonrpc.php',
  :user => 'admin',
  :password => '9tx#r3&RxJq4'
)

print zbx.templates.get_ids_by_host( :hostids => [zbx.hosts.get_id(:host => "Prod_TWS_NY_Bidder_1")] )
