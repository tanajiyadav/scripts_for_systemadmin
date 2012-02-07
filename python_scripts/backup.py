#!/usr/bin/env python
''' backup script to make a backup of the files
    that are newer than 12 hours in the 
    home directory 
    see 
    " man find "
    " man tar  "
    for more information on the dates and the specific options
    on how to set different specifications for the selections
    '''
import sys
import os
import time

if (len(sys.argv) != 2):
  # if argument count is different 
  # than 2, then there is an error  
  print "Error on usage -> binary <hours_count_back>"
  quit()
else:
  # convert to integer value
  hours_back = int(sys.argv[1])

message_start = "Operation is starting".center(50, '-')
message_end   = "Operation terminated with success".center(50,'-')
#
print message_start
# source directories to check for backup
source = [ '/home/utab/thesis', '/home/utab/Documents' ]
# find files newer than 24 hours
# change to the target directories
newer_files = []
#
log_file = "log.dat"
# cmd to find newer files
# than 24 hours
cmd_find = "find . -type f -a -mmin " + str(-hours_back*60) + " > " + log_file
for directory in source:
  # iterate over the directories
  # change to the directory first
  os.chdir(directory)
  # apply the command
  os.system(cmd_find);
  # files are found with respect to the current directory
  # change the "." to directory for correct backups
  c = 0
  # process log file
  files = []
  lines = []
  log_in = open(log_file,'r')
  # read lines without \n character
  while 1:
      l = log_in.readline()
      if not l: 
        break
      # do not include the newline
      # -1 is for that
      lines.append(l[:-1])
  #   
  for l in lines:
      l_dummy  = l.replace( '.', directory, 1 )
      files.append(l_dummy)
  # extend the list with newer files
  newer_files.extend(files)
#print newer_files
print newer_files
# date
today =  time.strftime('%Y%m%d')
# current time of the date
# possible to do different backups in different times of the day
now   = time.strftime('%H%M%S')
#
target_directory = "/home/utab/"
target = target_directory + today + "_" + now + \
         '.tgz' 

# do the actual back up
backup_cmd = "tar -C ~ -zcvf %s %s" % ( target , ' '.join(newer_files) )
status = os.system(backup_cmd)

if status == 0:
    print message_end
else:
    print "Back-up failed"

