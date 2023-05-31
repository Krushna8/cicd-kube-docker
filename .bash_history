apt get update
apt-get update
clear
spt install awscli
apt install awscli
clear
aws configure
clear
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
ls
chmod +x ./kubectl 
mv kubectl /usr/local/bin/kubectl
kubectl --help
clear
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
ls
chmod +x ./kops-linux-amd64 
mv kops-linux-amd64 /usr/local/bin/kops
kops --help
clear
nslookup -type=ns kubevpro.kpanda.in
kops create cluster --name=kubevpro.kpanda.in \ 
--state=s3://kops-state852 --zones=ap-south-1a,ap-south-1b \ 
--node-count=2 --node-size=t3.small --master-size=t3.medium --dns-zone=kubevpro.kpanda.in \ 
--node-volume-size=8 --master-volume-size=8
clear
kops create cluster --name=kubevpro.kpanda.in --state=s3://kops-state852 --zones=ap-south-1a,ap-south-1b --node-count=2 --node-size=t3.small --master-size=t3.medium --dns-zone=kubevpro.kpanda.in --node-volume-size=8 --master-volume-size=8
clear
kops update cluster --name kubevpro.kpanda.in --state=s3://kops-state852 --yes --admin
kops validate cluster --name kubevpro.kpanda.in --state=s3://kops-state852
clear
kops delete cluster --name kubevpro.kpanda.in --state=s3://kops-state852 --yes
clear
