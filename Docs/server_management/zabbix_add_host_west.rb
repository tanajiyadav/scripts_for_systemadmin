#!/usr/bin/ruby
require "rubygems"
require "zabbixapi"

zbx = ZabbixApi.connect(
  :url => 'http://54.186.146.58/zabbix/api_jsonrpc.php',
  :user => 'admin',
  :password => 'zabbix'
)

zbx.hosts.create(
  :host => "QA_WTE",
  :interfaces => [
    {
      :type => 1,
      :main => 1,
      :ip => '172.31.22.246',
      :dns => 'ip-172-31-22-246.ec2.internal',
      :port => 10050,
      :useip => 1
    }
  ],
  :groups => [ :groupid => zbx.hostgroups.get_id(:name => "Linux_servers") ]
)
