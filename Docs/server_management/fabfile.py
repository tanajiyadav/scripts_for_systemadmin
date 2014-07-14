from fabric.api import *
import os

env.user = 'root'
env.roledefs = {
      'brandfxstaging' : ["Staging_East_Brandfx"],
      'brandfx_east' : ["Prod_East_Brandfx"],
      'wtestaging' : ["Staging_East_WTE"],
      'wte_east': ["Prod_East_WTE"],
      'twsstaging' : ["Staging_East_TWS_V2"],  
      'tws_east': ["Prod_East_TWS_Triggers_1","Prod_East_TWS_Triggers1_1","Prod_East_TWS_Triggers_2","Prod_East_TWS_Triggers1_2","Prod_East_TWS_Triggers_3","Prod_East_TWS_Triggers1_3"],
      'utility_east': ["Prod_East_Puppet","Prod_East_RT_Mail","Prod_East_Mediawiki","Prod_East_LogStash","Prod_East_Zabbix"],
      'mysql_east': ["Prod_East_MySQL_Slave","Prod_East_MySQL_Master"],
      'mysqlstaging' : ["Staging_East_MySQL_Master","Staging_East_MySQL_Slave"],
      'alleast' : ["Prod_East_Brandfx","Prod_East_WTE","Prod_East_TWS_Triggers_1","Prod_East_TWS_Triggers1_1","Prod_East_TWS_Triggers_2","Prod_East_TWS_Triggers1_2","Prod_East_TWS_Triggers_3","Prod_East_TWS_Triggers1_3","Prod_East_MySQL_Slave","Prod_East_MySQL_Master"],
       'allstaging' : ["Staging_East_Brandfx","Staging_East_WTE","Staging_East_TWS_V2","Staging_East_MySQL_Master","Staging_East_MySQL_Slave"],  

      'tws_west': ["Prod_West_TWS_Triggers_1","Prod_West_TWS_Triggers1_1","Prod_West_TWS_Triggers_2","Prod_West_TWS_Triggers1_2","Prod_West_TWS_Triggers_3","Prod_West_TWS_Triggers1_3"],
      'wte_west': ["Prod_West_WTE"],  
      'mysql_west': ["Prod_West_MySQL_Slave"],
      'utility_west': ["Prod_West_Zabbix","Prod_West_RT_Mail","Prod_West_LogStash"],
      'allwest' : ["Prod_West_TWS_Triggers_1","Prod_West_TWS_Triggers1_1","Prod_West_TWS_Triggers_2","Prod_West_TWS_Triggers1_2","Prod_West_TWS_Triggers_3","Prod_West_TWS_Triggers1_3","Prod_West_WTE","Prod_West_MySQL_Slave"],
}
env.port = 2020
def puppet_apply():
    """
    Apply Puppet manifests
    """
    run('puppet agent -t --server "ip-172-31-8-70.ec2.internal";true')

def puppet_apply_module(tags):
  """
  Apply Puppet manifest
  """
  run('puppet agent -t --server "ip-172-31-8-70.ec2.internal" --tags %s;true' %tags)

def runcmd(arg):
   """
   Run Any Command 
   """
   run("%s" %arg)

def check_service(arg):
  """
  Check Service Status
  """
  run("/etc/init.d/%s status" %arg)

def restart_service(arg):
  """
  Restart Service
  """
  run("/etc/init.d/%s restart" %arg)

#def upload_file():
#  """
#  upload puppet file
#  """
#  put("/etc/sysconfig/puppet", "/etc/sysconfig/puppet")
