#!/bin/bash

red='\033[4;31m'
green='\033[4;32m'
yellow='\033[4;33m'
blue='\033[1;34m'
plain='\033[0m'

if [ -t 1 ]; then
	export PS1="\e[1;34m[\e[1;33m\u@\e[1;32mdocker-\h\e[1;37m:\w\[\e[1;34m]\e[1;36m\\$ \e[0m"
fi

if [ -f "/etc/envfile" ]; then
export $(grep -v '^#' /etc/envfile | xargs)
fi

INTERFACE=`ip route | grep "default via" |awk '{ print $5}'`
# Aliases
alias l='ls -lAsh --color'
alias ls='ls -C1 --color'
alias cp='cp -ip'
alias rm='rm -i'
alias mv='mv -i'
alias tmux='tmux -u'
alias h='cd ~;clear;'
alias speed='time curl -o /dev/null http://cachefly.cachefly.net/10mb.test'
alias cancel_limit='tc qdisc del dev $INTERFACE root tbf rate $RATE burst $BURST latency $LATENCY'
alias view_limit='tc qdisc show dev $INTERFACE && tc -s qdisc ls dev $INTERFACE'

. /etc/os-release

echo -e -n '\E[1;34m'


echo ""
figlet -k -f big -c -m-1 -w 120 "Welcome `hostname`"
echo " # ------------------------------------------------------------------------------------------------ #"
vnstat -m
echo ""
echo " # ------------------------------------------------------------------------------------------------ #"
if [ -f "/etc/member" ]; then
MEMBER=`cat /etc/member`
if [ "$MEMBER" == "0" ]; then
echo " # `cat /etc/npsnotice` "
else
echo " # 容器ID： `cat /etc/dockerid` "
fi
fi
echo " # 查看每月流量        输入 <vnstat -m> "
echo " # 查看每日流量        输入 <vnstat -d> "
echo " # 查看5秒实时浏览     输入 <vnstat -tr> "
echo " # 查看接口列表        输入 <vnstat --iflist> "
echo " # 删除Docker接口      输入 <vnstat -i docker0 --remove --force> "
echo " # 更多vnstat设置      输入 <vnstat --longhelp> "
echo " # 查看带宽限制        输入 <view_limit> "
echo " # 取消带宽限制        输入 <cancel_limit> "
echo " # 测试主机速度        输入 <speed> "
echo " # ------------------------------------------------------------------------------------------------ #"
if [ -f "/etc/member" ]; then
echo " # "
QQ=`cat /etc/envfile | grep QQ | awk -F "=" '{ print $2}'`
echo -e "${blue} # 技术支持QQ:${plain} ${red}$QQ${plain}"
fi
echo -e -n '\E[1;34m'
echo -e '\E[0m'
