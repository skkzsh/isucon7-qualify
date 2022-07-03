#!/bin/bash
set -euvx

sudo truncate -s 0 -c /var/log/nginx/access.log
sudo truncate -s 0 -c /var/log/mysql/mysql-slow.log
# mysqladmin flush-logs

cd ~/isubata/webapp/go
make
sudo systemctl restart isubata.golang

sudo systemctl restart mysql
sudo systemctl restart nginx

cd ~/isubata/bench
bin/bench -remotes=127.0.0.1 -output result-$(date +%Y%m%d-%H%M%S).json

# sudo cat /var/log/nginx/access.log | alp json --sort avg -r -m '^/icons/[0-9a-f]*\.png$' | tee alp-$(date +%Y%m%d-%H%M%S).log
sudo cat /var/log/nginx/access.log | alp json --sort avg -r -m '^/icons/[0-9a-f]*\.png$','^/icons/[0-9a-f]*\.jpg$','^/channel/[0-9]*$','^/profile/.*$','^/history/[0-9]*$' | tee alp-$(date +%Y%m%d-%H%M%S).log

# sudo mysqldumpslow /var/log/mysql/mysql-slow.log
# sudo pt-query-digest /var/log/mysql/mysql-slow.log | tee pt-query-digest-$(date +%Y%m%d-%H%M%S).log

# go tool pprof -http=:10060 http://localhost:6060/debug/pprof/profile

