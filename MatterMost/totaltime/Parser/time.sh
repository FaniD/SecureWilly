#!/bin/bash

#Comment lines of run.sh and uncomment lines with time in dynamic parser
sed -i "54s,./,#./," dynamic_parser.sh
sed -i "55s,#,," dynamic_parser.sh
sed -i "56s,#,," dynamic_parser.sh
sed -i "57s,#,," dynamic_parser.sh
sed -i "58s,#,," dynamic_parser.sh

sed -i "117s,./,#./," dynamic_parser.sh
sed -i "118s,#,," dynamic_parser.sh
sed -i "119s,#,," dynamic_parser.sh
sed -i "120s,#,," dynamic_parser.sh
sed -i "121s,#,," dynamic_parser.sh
