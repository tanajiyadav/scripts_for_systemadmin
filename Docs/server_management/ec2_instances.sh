#!/bin/sh
echo "east region"
/usr/bin/list_instances --headers PrivateIP,T:Name,IP | grep -v "^\(Private\|None\|IP|-\)" | grep 172 > /tmp/east_zone
#cat /tmp/east_zone 
count=$(cat /tmp/east_zone | wc -l)
echo total instances ${count}.

/usr/bin/list_instances --headers PrivateIP,T:Name,IP | grep -v "^\(Private\|None\|IP|-\)"
echo "west region"
/usr/bin/list_instances -r us-west-2 --headers PrivateIP,T:Name,IP | grep -v "^\(Private\|None\|IP|-\)" | grep 172 > /tmp/west_zone
count=$(cat /tmp/west_zone | wc -l)
echo total instances ${count}.
cat /tmp/west_zone
