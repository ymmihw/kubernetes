#!/bin/bash

yum -y install yum-utils

yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#时间同步
yum install ntpdate -y
ntpdate time.windows.com

#关闭防火墙

systemctl stop firewalld
systemctl disable firewalld

#关闭 selinux

sed -i 's/enforcing/disabled/' /etc/selinux/config

#关闭swap分区

sed -ri 's/.*swap.*/#&/' /etc/fstab

#配置repo

cat > /etc/yum.repos.d/kubernetes.repo << EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

#安装Kubeadm 和 Docker

yum install kubeadm docker-ce -y
systemctl restart docker && systemctl enable docker
systemctl  restart kubelet && systemctl enable kubelet

modprobe br_netfilter
echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
echo 1 > /proc/sys/net/ipv4/ip_forward

reboot