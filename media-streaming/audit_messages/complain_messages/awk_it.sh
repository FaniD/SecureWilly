awk '/capability/ {print $16;}' kernlogs_server
#awk 'BEGIN {FS="=";} {print $2;}' caps
awk 'BEGIN {FS="=";} {gsub(/"/,"",$2); print $2;}' caps
#then strip "" with python
