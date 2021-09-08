#!/bin/bash

if [ -t 1 ]; then
	export PS1="\e[1;34m[\e[1;33m\u@\e[1;32mdocker-\h\e[1;37m:\w\[\e[1;34m]\e[1;36m\\$ \e[0m"
fi

# Aliases
alias l='ls -lAsh --color'
alias ls='ls -C1 --color'
alias cp='cp -ip'
alias rm='rm -i'
alias mv='mv -i'
alias h='cd ~;clear;'
alias proxyip='time curl -x http://$USER:$PASSWD@127.0.0.1:$PORT ipinfo.io'
alias proxyspeed='time curl -o /dev/null -x http://$USER:$PASSWD@127.0.0.1:$PORT http://cachefly.cachefly.net/10mb.test'
alias changeip='/gost/entrypoint.sh changeip'
alias lookallip='cat /tmp/ip.txt'
. /etc/os-release

echo -e -n '\E[1;34m'
figlet -w 120 "GOST S5"
echo "#查看代理IP 输入 <proxyip> "
echo "#更换代理IP 输入 <changeip> "
echo "#查看已换过的IP 输入 <lookallip> "
echo "#测试代理速度 输入 <proxyspeed> "
echo -e -n '\E[1;34m'
echo -e '\E[0m'
