#!/usr/bin/ruby
require "rubygems"
require "zabbixapi"

zbx = ZabbixApi.connect(
  :url => 'http://172.31.32.163/zabbix/api_jsonrpc.php',
  :user => 'admin',
  :password => 'zabbix'
)

zbx.hosts.create(
  :host => "puppet",
  :interfaces => [
    {
      :type => 1,
      :main => 1,
      :ip => '172.31.8.70',
      :dns => 'ip-172-31-8-70.ec2.internal',
      :port => 10050,
      :useip => 1
    }
  ],
  :groups => [ :groupid => zbx.hostgroups.get_id(:name => "Linux_servers") ]
)
