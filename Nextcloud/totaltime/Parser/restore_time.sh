#!/bin/bash

#Comment lines of run.sh and uncomment lines with time in dynamic parser
sed -i "54s,#,," dynamic_parser.sh
sed -i "55s,echo,#echo," dynamic_parser.sh
sed -i "56s,time,#time," dynamic_parser.sh
sed -i "57s,cat,#cat," dynamic_parser.sh
sed -i "58s,rm,#rm," dynamic_parser.sh

sed -i "117s,#,," dynamic_parser.sh
sed -i "118s,echo,#echo," dynamic_parser.sh
sed -i "119s,time,#time," dynamic_parser.sh
sed -i "120s,cat,#cat," dynamic_parser.sh
sed -i "121s,rm,#rm," dynamic_parser.sh
