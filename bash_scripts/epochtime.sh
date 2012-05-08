#!/bin/bash
START=`date +%s`
sleep 10
FINISH=`date +%s`
#echo "Finished Backup time is $FINISH"
diff=$((FINISH - START))
echo -n "***** Total Run Time: "
HRS=`expr $diff / 3600`
MIN=`expr $diff % 3600 / 60`
SEC=`expr $diff % 3600 % 60`
if [ $HRS -gt 0 ]
then
 echo -n "$HRS hrs. "
fi
if [ $MIN -gt 0 ]
then
 echo -n "$MIN mins. "
fi
if [ $SEC -gt 0 ]
then
 if [ $MIN -gt 0 ]
 then
  echo "and $SEC secs."
 elif [ $HRS -gt 0 ]
 then
  echo "and $SEC secs."
 else
 echo "$SEC secs."
 fi
fi

