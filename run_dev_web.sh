#!/bin/bash
all_ips=$(hostname -i) 
my_local_ip=${all_ips%% *} 
echo $my_local_ip 
export MY_BACKEND_IP=$my_local_ip

flutter run -d chrome --dart-define-from-file=.env --web-port=33885 --dart-define=BACKEND_IP=${MY_BACKEND_IP} --dart-define=SCHEME=http
