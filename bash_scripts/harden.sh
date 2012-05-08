#!/bin/bash
# Description :  Script that resets some system settings for
#                Linux security policy.  These settings are considered
#                to be low risk - having no impact on users and/or applications.
#
#Variables

SuidFileList="/usr/X11R6/bin/XFree86 /usr/bin/X11/Xwrapper /usr/sbin/traceroute /usr/sbin/traceroute6 /usr/sbin/usernetctl /bin/mount /bin/umount"
RpmPkg=" acpid apmd kernel-pcmcia-cs pcmcia-cs"
RootHome=`grep ^root: /etc/passwd|awk -F: '{print $6}'`
ProfFiles="/etc/zprofile /etc/profile /etc/csh.login $RootHome/.bash_profile"
>$LogFile

#Functions
RemSuid ()
{
  echo "=========================================================================================" >>$LogFile
  echo "Now removing suid settings...." >>$LogFile
  echo "=========================================================================================" >>$LogFile
  printf '\t%-25s\t%-25s\t%-25s\n' "Old Perm" File "New Perm" >>$LogFile
  for FILE in `echo $SuidFileList`
  do
    if [ -f $FILE ];then
      OldPerm=`ls -l $FILE|awk '{print $1}'`
      chmod u-s $FILE
      NewPerm=`ls -l $FILE|awk '{print $1}'`
      printf '\t%-25s\t%-25s\t%-25s\n' $OldPerm $FILE $NewPerm >>$LogFile
    fi
  done
}


RemPkgs ()
{
  echo "=========================================================================================" >>$LogFile
  echo "Now removing Packages not needed...." >>$LogFile
  echo "=========================================================================================" >>$LogFile
  for PKG in `echo $RpmPkg`
  do
     if ( rpm -qa|grep -q $PKG )
     then
        printf '\t%-25s\n' "$PKG is installed - now deleting" >>$LogFile
        rpm -e $PKG >>$LogFile 2>&1
     else
        printf '\t%-25s\n' "$PKG not installed - nothing to do" >>$LogFile
     fi
  done
                  yum -y remove Canna FreeWnn FreeWnn-libs gpm cups sendmail postfix 
                  yum -y remove iiimf*
                  yum -y remove xorg*
                  yum -y remove portmap*
                  yum -y remove pcmcia-cs bluez*
                  yum -y remove pcsc*
                  yum -y remove gamin
		  yum -y install bc	
}

AddUmask ()
{
  echo "=========================================================================================" >>$LogFile
  echo "Now adding umask config to profile files...." >>$LogFile
  echo "=========================================================================================" >>$LogFile
  for FILE in `echo $ProfFiles`
  do
    if [ -f $FILE ];then
       if ( grep -q -i umask $FILE )
       then
          printf '\t%-25s\n' "$FILE already has line, nothing to do" >>$LogFile
       else
          printf '\t%-25s\n' "now adding umask line to $FILE ...." >>$LogFile
          echo "umask 022" >> $FILE
       fi
    else
      printf '\t%-25s\n' "$FILE does not exist, nothing to do" >>$LogFile
    fi
done
}

UserDel ()
{
  echo "=========================================================================================" >>$LogFile
  echo "Now Deleting users...." >>$LogFile
  echo "=========================================================================================" >>$LogFile
        for i in apache named nfsnobody smmsp nscd ntp games gopher uucp lp avahi avahi-autoipd
        do
                if ( grep $i /etc/passwd )
                then
                        userdel $i
                        echo "$i user deleted " >>$LogFile
                else
                        echo "$i user does not exist, nothing to do" >>$LogFile
                fi
        done
}


function closeinittab ()
{
echo "=========================================================================================" >>$LogFile
  echo "Shutting down CTRL+ALT+DEL keys ...." >>$LogFile
  echo "=========================================================================================" >>$LogFile
echo "Shutting down CTRL+ALT+DEL keys"
perl -p -i -e 's/ca::ctrlaltdel:\/sbin\/shutdown -t3 -r now/ca::ctrlaltdel:\/sbin\/shutdown -t3 -a -r now/g' /etc/inittab

echo "Shutting down system consoles" >>$LogFile
perl -p -i -e 's/3:2345:respawn:\/sbin\/mingetty tty3/#3:2345:respawn:\/sbin\/mingetty tty3/g' /etc/inittab
perl -p -i -e 's/4:2345:respawn:\/sbin\/mingetty tty4/#4:2345:respawn:\/sbin\/mingetty tty4/g' /etc/inittab
perl -p -i -e 's/5:2345:respawn:\/sbin\/mingetty tty5/#5:2345:respawn:\/sbin\/mingetty tty5/g' /etc/inittab
perl -p -i -e 's/6:2345:respawn:\/sbin\/mingetty tty6/#6:2345:respawn:\/sbin\/mingetty tty6/g' /etc/inittab
perl -p -i -e 's/x:5:respawn:\/etc\/X11\/prefdm -nodaemon/#x:5:respawn:\/etc\/X11\/prefdm -nodaemon/g' /etc/inittab

chown root.root /etc/inittab

touch -r /etc/backup/inittab /etc/inittab

/sbin/init q
/sbin/telinit q

}

function syspolicy ()
{

  echo "=========================================================================================" >>$LogFile
  echo "Now applying system policies ...." >>$LogFile
  echo "=========================================================================================" >>$LogFile

perl -p -i -e 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/g' /etc/login.defs
perl -p -i -e 's/^PASS_MIN_LEN.*/PASS_MIN_LEN   8/g' /etc/login.defs
echo "Applied password aging" >> $LogFile

#Remove .rhosts file
find / -type f -name .rhosts -exec rm -f {} \;
echo "Removed .rhosts file" >> $LogFile

## Removing TMOUT and HISTSIZE entries
perl -p -i -e 's/TMOUT.*\n//' /etc/profile
perl -p -i -e 's/HISTSIZE.*\n//' /etc/profile
echo "Removed TMOUT and HISTSIZE entries from profile" >> $LogFile

# Setting timeout in /etc/profile
echo "TMOUT=300" >> /etc/profile
echo "export TMOUT" >> /etc/profile
echo "Setting TMOUT=300 to profile" >> $LogFile

echo "HISTSIZE=1000" >> /etc/profile
echo "export HISTSIZE" >> /etc/profile
echo "Setting HISTSIZE=1000 to profile" >> $LogFile

touch -r /etc/backup/login.defs /etc/login.defs
touch -r /etc/backup/hosts.allow /etc/hosts.allow
touch -r /etc/backup/hosts.deny /etc/hosts.deny
touch -r /etc/backup/profile /etc/profile

}

function remove_sysusers ()
{

  echo "=========================================================================================" >>$LogFile
  echo "Removing Users/groups not needed...." >>$LogFile
  echo "=========================================================================================" >>$LogFile

for users in  ntp haldaemon mail halt shutdown pegasus smmsp dbus adm desktop ftp games gdm gnats gopher identd vcsa irc list lp lpd news nfsnobody operator postgres proxy rpc rpcuser sync telnetd uucp xfs netdump nscd mailnull smmsp apache  named desktop distcache sabayon postifix mailman sdb pcap  webalizer squid pvm gdm  test office avahi 
do
                if ( grep $users /etc/passwd )
                then
                        userdel $users
                        echo "$users user deleted " >>$LogFile
                else
                        echo "$users user does not exist, nothing to do" >>$LogFile
                fi
done

for groups in lock ntp haldaemon mail halt shutdown lp news uucp proxy pegasus smmsp dbus  postgres www-data backup operator list irc src gnats staff games users gdm telnetd gopher ftp rpc rpcuser nfsnobody xfs desktop floppy netdump dip postdrop distcache  webalizer squid sabayon pvm sdba wheel test office sys tty disk
do
                if ( grep $groups /etc/group )
                then
                        groupdel $i
                        echo "$groups group deleted " >>$LogFile
                else
                        echo "$groups group does not exist, nothing to do" >>$LogFile
                fi
done

}

function stop_start_services ()
{

  echo "=========================================================================================" >>$LogFile
  echo "Start/Stop services ...." >>$LogFile
  echo "=========================================================================================" >>$LogFile

for stopservice in anacron apmd atd autofs irda isdn kudzu lpd netfs nfs winbind pcmcia netdump xinetd cups rhnsd winbind sm\
b snmpd snmptrapd xfs named rwhod dhcpd dhcrelay arptables_jf yppasswdd ypserv ypxfrd  netdump-server mdmonitor mdmpd ypbind\
 bluetooth tux ipmi gpm iptables  ip6tables
do
    echo "Disabling $stopservice" >>$LogFile
    /etc/rc.d/init.d/$stopservice stop
    /sbin/chkconfig $stopservice off
done

for startservice in httpd mysql microcode_ctl syslog netfs network random sshd portmap crond sysstat keytable random rawdevices irqbalance
do
    echo "Enabling $startservice in runlever 2 & 3" >>$LogFile
    /sbin/chkconfig --level 23 $startservice on
done

}

function check_files ()
 {
 echo "=========================================================================================" >>$LogFile
 echo "Set Attributes and Permissions to world writable Files ...." >>$LogFile
 echo "=========================================================================================" >>$LogFile


chmod 1777  /tmp
chmod 1777  /usr/tmp

####Lock on Modification
chattr +i /etc/passwd
chattr +i /etc/shadow
chattr +i /etc/hosts.allow
chattr +i /etc/hosts.deny

#####Append only Mode
chattr +a /var/log/secure
chattr +a .bash_history
chattr +i .bash_history

###set ulimt
echo "ulimit -n 90000" >> /root/.bashrc
source /root/.bashrc

###securing /dev/shm
cp /etc/fstab   /etc/fstab.bak
perl -pi -e 's/defaults/defaults,nosuid,noexec/ if /shm/' /etc/fstab
mount -o remount /dev/shm
}


####Allowing Only root to Access system important Files
function systemsecure ()
{
chmod 700 /bin/ping
chmod 700 /usr/bin/finger
chmod 700 /usr/bin/who
chmod 700 /usr/bin/w
chmod 700 /usr/bin/locate
chmod 700 /usr/bin/whereis
chmod 700 /sbin/ifconfig
chmod 700 /bin/vi
chmod 700 /usr/bin/which
chmod 700 /usr/bin/gcc
chmod 700 /usr/bin/make
chmod 700 /bin/rpm
chmod 700 /usr/bin/wget
chmod 700 /usr/bin/telnet
chmod 700 /usr/local/bin/lynx
chmod 700 /usr/bin/links
chmod 700 /usr/bin/bcc
chmod 700 /usr/bin/byacc
chmod 700 /usr/bin/cc
chmod 700 /usr/bin/gcc
chmod 700 /usr/bin/i386-redhat-linux-gcc
chmod 700 /usr/bin/perlcc
chmod 700 /usr/bin/yacc
chmod 700 /usr/bin/curl
chmod 700 /usr/bin/lwp-*
chmod 700 /usr/bin/*ncftp*

####Disable SELINUX
perl -pi -e 's/enforcing/disabled/ if /SELINUX=/' /etc/selinux/config

}




# Main Function

RemSuid
RemPkgs
AddUmask
UserDel
closeinittab
syspolicy
remove_sysusers
stop_start_services
check_files
systemsecure
