1.Generate access and secret key so my terraform have access to the AWS cloud
2.Install terraform
3.Create Key pair for access to EC2
4.Change region to eu-west-3 in .tf and ami id and add my key pair for access to EC2
5.Add admin access to my IAM user
6.Do terraform init, terraform plan and terraform apply to set up aws infrastructure
7.Run setup.sh script to install Kubernetes on every EC2 instances
8.Change hostname for every machine and add <IP> <hostname> in /etc/hosts for every machine for every machine
9.sudo kubeadm init --control-plane-endpoint="IP" - to initialize master node
10. Run next commands:
mkdir -p $HOME/.kube 
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 
sudo chown $(id -u):$(id -g) $HOME/.kube/config
11 Runjoin command on worker to join to cluster:
kubeadm join 10.0.1.112:6443 --token 
12.kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.0/manifests/calico.yaml
13.Check status of nodes in cluster
root@ip-10-0-1-112:/home/ubuntu# kubectl get nodes
NAME       STATUS   ROLES           AGE     VERSION
master     Ready    control-plane   2m14s   v1.28.15
worker-1   Ready    <none>          91s     v1.28.15
worker-2   Ready    <none>          87s     v1.28.15
14.Create pv.yaml, redis-service.yaml, redis-statefulset.yaml(configs attached.)

root@ip-10-0-1-100:/home/ubuntu# kubectl get pods
NAME      READY   STATUS    RESTARTS   AGE
redis-0   1/1     Running   0          18s
redis-1   1/1     Running   0          10s
root@ip-10-0-1-100:/home/ubuntu# kubectl get statefulset
NAME    READY   AGE
redis   2/2     2m57s
root@ip-10-0-1-100:/home/ubuntu# kubectl get pv
NAME         CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                  STORAGECLASS   REASON   AGE
pv-redis-0   1Gi        RWO            Retain           Bound    default/data-redis-0                           16m
pv-redis-1   1Gi        RWO            Retain           Bound    default/data-redis-1                           16m
root@ip-10-0-1-100:/home/ubuntu# kubectl get pvc
NAME           STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-redis-0   Bound    pv-redis-0   1Gi        RWO                           16m
data-redis-1   Bound    pv-redis-1   1Gi        RWO                           15m

root@ip-10-0-1-100:/home/ubuntu# kubectl exec -it redis-0 -- redis-cli
127.0.0.1:6379> 
root@ip-10-0-1-100:/home/ubuntu# kubectl exec -it redis-1 -- redis-cli
127.0.0.1:6379> 

15. Create Daemonset Falco(config attached)

root@ip-10-0-1-100:/home/ubuntu# kubectl logs -l app=falco -n kube-system
2024-11-29T15:40:14+0000: System info: Linux version 6.8.0-1015-aws (buildd@lcy02-amd64-053) (x86_64-linux-gnu-gcc-11 (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0, GNU ld (GNU Binutils for Ubuntu) 2.38) #16~22.04.1-Ubuntu SMP Mon Aug 19 19:38:17 UTC 2024
2024-11-29T15:40:14+0000: Loading rules from:
2024-11-29T15:40:15+0000:    /etc/falco/falco_rules.yaml | schema validation: ok
2024-11-29T15:40:16+0000:    /etc/falco/falco_rules.local.yaml | schema validation: none
2024-11-29T15:40:16+0000: The chosen syscall buffer dimension is: 8388608 bytes (8 MBs)
2024-11-29T15:40:16+0000: Starting health webserver with threadiness 2, listening on 0.0.0.0:8765
2024-11-29T15:40:16+0000: Loaded event sources: syscall
2024-11-29T15:40:16+0000: Enabled event sources: syscall
2024-11-29T15:40:16+0000: Opening 'syscall' source with modern BPF probe.
2024-11-29T15:40:16+0000: One ring buffer every '2' CPUs.
2024-11-29T15:42:43+0000: System info: Linux version 6.8.0-1015-aws (buildd@lcy02-amd64-053) (x86_64-linux-gnu-gcc-11 (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0, GNU ld (GNU Binutils for Ubuntu) 2.38) #16~22.04.1-Ubuntu SMP Mon Aug 19 19:38:17 UTC 2024
2024-11-29T15:42:43+0000: Loading rules from:
2024-11-29T15:42:43+0000:    /etc/falco/falco_rules.yaml | schema validation: ok
2024-11-29T15:42:44+0000:    /etc/falco/falco_rules.local.yaml | schema validation: none
2024-11-29T15:42:44+0000: The chosen syscall buffer dimension is: 8388608 bytes (8 MBs)
2024-11-29T15:42:44+0000: Starting health webserver with threadiness 2, listening on 0.0.0.0:8765
2024-11-29T15:42:44+0000: Loaded event sources: syscall
2024-11-29T15:42:44+0000: Enabled event sources: syscall
2024-11-29T15:42:44+0000: Opening 'syscall' source with modern BPF probe.
2024-11-29T15:42:44+0000: One ring buffer every '2' CPUs.
root@ip-10-0-1-100:/home/ubuntu# kubectl get pods -n kube-system -l app=falco
NAME          READY   STATUS    RESTARTS   AGE
falco-rgpqw   1/1     Running   0          6m31s
falco-vtwpp   1/1     Running   0          4m24s