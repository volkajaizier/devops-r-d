Create EKS Cluster
aws eks create-cluster \
  --name my-eks-cluster \
  --region eu-west-3 \
  --role-arn arn:aws:iam::817539924586:role/EKS-devops-role \
  --resources-vpc-config subnetIds=subnet-03cdb388b1946f040,subnet-036bf72645a18b858

Create a role with next policies:
AmazonEKSWorkerNodePolicy
AmazonEC2ContainerRegistryReadOnly
AmazonEKS_CNI_Policy


add worker nodes

aws eks create-nodegroup \
  --cluster-name my-eks-cluster \
  --nodegroup-name worker-nodes \
  --subnets subnet-03cdb388b1946f040 subnet-036bf72645a18b858 \
  --instance-types t3.medium \
  --scaling-config minSize=2,maxSize=5,desiredSize=2 \
  --ami-type AL2_x86_64 \
  --node-role arn:aws:iam::817539924586:role/eks-nodegroup-role

Config Kubectl 
aws eks update-kubeconfig --region eu-west-3 --name my-eks-cluster

vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ aws eks update-kubeconfig --region eu-west-3 --name my-eks-cluster
Added new context arn:aws:eks:eu-west-3:817539924586:cluster/my-eks-cluster to /home/vladv/.kube/config

kubectl get nodes

vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get nodes
NAME                                        STATUS   ROLES    AGE   VERSION
ip-10-0-30-134.eu-west-3.compute.internal   Ready    <none>   29s   v1.31.2-eks-94953ac
ip-10-0-8-113.eu-west-3.compute.internal    Ready    <none>   34s   v1.31.2-eks-94953ac

create configmap.yml
kubectl apply -f configmap.yml

ladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      53m
website-config     1      2m3s

create nginx deployment
kubectl apply -f deployment-nginx.yml


create nginx-loadbalancer0-service
kubectl apply -f nginx-service.yml

vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   2/2     2            2           2m30s
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get service
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)        AGE
kubernetes      ClusterIP      172.20.0.1      <none>                                                                    443/TCP        59m
nginx-service   LoadBalancer   172.20.117.36   ab127b7048fc94a75834ef66d49b9689-2055352213.eu-west-3.elb.amazonaws.com   80:31102/TCP   2m48s



create storageclass and pvc
kubectl apply -f storageclass.yml
kubectl apply -f pvc.yml


create pod-nginx
kubectl apply -f pod.yml

(didn`t work until CSI driver isntalled and additional policy fr EBS CSI driver added for the Nodes group)

vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get pvc
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
ebs-pvc   Bound    pvc-500560b4-7a18-4059-9541-5737d8a3c282   1Gi        RWO            ebs-sc         <unset>                 19s
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get pod
NAME                               READY   STATUS    RESTARTS   AGE
app-pod                            1/1     Running   0          10m
nginx-deployment-7755b9c67-8frrl   1/1     Running   0          16m
nginx-deployment-7755b9c67-x6lkg   1/1     Running   0          16m
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get storageclasss
error: the server doesn't have a resource type "storageclasss"
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ ^C
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get storageclass
NAME     PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
ebs-sc   kubernetes.io/aws-ebs   Delete          Immediate              false                  12m
gp2      kubernetes.io/aws-ebs   Delete          WaitForFirstConsumer   false                  74m

create job.yml
kubectl apply -f job.yml

vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get jobs
NAME        STATUS     COMPLETIONS   DURATION   AGE
hello-job   Complete   1/1           6s         49s
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl logs job/hello-job

Hello from EKS!

create httpd.yml and hhtpd-service.yml
kubectl apply -f httpd.yml
kubectl apply -f httpd-service.yml

vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get deployment test-app
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
test-app   2/2     2            2           48s
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl describe deployment test-app
Name:                   test-app
Namespace:              default
CreationTimestamp:      Mon, 09 Dec 2024 19:20:46 +0200
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=test-app
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=test-app
  Containers:
   httpd:
    Image:        httpd
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   test-app-6bc578bb45 (2/2 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  57s   deployment-controller  Scaled up replica set test-app-6bc578bb45 to 2
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl describe service test-app
Name:              test-app-service
Namespace:         default
Labels:            <none>
Annotations:       <none>
Selector:          app=test-app
Type:              ClusterIP
IP Family Policy:  SingleStack
IP Families:       IPv4
IP:                172.20.23.86
IPs:               172.20.23.86
Port:              <unset>  80/TCP
TargetPort:        80/TCP
Endpoints:         10.0.29.201:80,10.0.7.119:80
Session Affinity:  None
Events:            <none>

create namespace

kubectl create namespace dev

vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl create namespace dev
namespace/dev created

create busybox-deployment.yml
kubectl apply -f busybox-deployment.yml
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl get pods -n dev
NAME                                  READY   STATUS    RESTARTS   AGE
busybox-deployment-75cd85d546-27mq5   1/1     Running   0          32s
busybox-deployment-75cd85d546-dwmq6   1/1     Running   0          32s
busybox-deployment-75cd85d546-kndqb   1/1     Running   0          32s
busybox-deployment-75cd85d546-rfv4c   1/1     Running   0          31s
busybox-deployment-75cd85d546-v6bnm   1/1     Running   0          31s

clear all resources
kubectl delete deployment --all
kubectl delete svc --all
kubectl delete pvc --all
kubectl delete namespace dev
aws eks delete-nodegroup --cluster-name my-eks-cluster --nodegroup-name worker-nodes
aws eks delete-cluster --name my-eks-cluster


vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl delete deployment --all
deployment.apps "nginx-deployment" deleted
deployment.apps "test-app" deleted
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl delete svc --all
service "kubernetes" deleted
service "nginx-service" deleted
service "test-app-service" deleted
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl delete namespace dev
namespace "dev" deleted
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ kubectl delete namespace dev^C
vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ aws eks delete-nodegroup --cluster-name my-eks-cluster --nodegroup-name worker-nodes
{
    "nodegroup": {
        "nodegroupName": "worker-nodes",
        "nodegroupArn": "arn:aws:eks:eu-west-3:817539924586:nodegroup/my-eks-cluster/worker-nodes/32c9d622-8d18-4fc6-105e-9d6c896a56ee",
        "clusterName": "my-eks-cluster",
        "version": "1.31",
        "releaseVersion": "1.31.2-20241121",
        "createdAt": "2024-12-09T18:33:51.590000+02:00",
        "modifiedAt": "2024-12-09T19:36:12.024000+02:00",
        "status": "DELETING",
        "capacityType": "ON_DEMAND",
        "scalingConfig": {
            "minSize": 2,
            "maxSize": 5,
            "desiredSize": 2
        },
        "instanceTypes": [
            "t3.medium"
        ],
        "subnets": [
            "subnet-03cdb388b1946f040",
            "subnet-036bf72645a18b858"
        ],
        "amiType": "AL2_x86_64",
        "nodeRole": "arn:aws:iam::817539924586:role/eks-nodegroup-role",
        "labels": {},
        "resources": {
            "autoScalingGroups": [
                {
                    "name": "eks-worker-nodes-32c9d622-8d18-4fc6-105e-9d6c896a56ee"
                }
            ]
        },
        "diskSize": 20,
        "health": {
            "issues": []
        },
        "updateConfig": {
            "maxUnavailable": 1
        },
        "tags": {}
    }
}
(END)

vladv@vvovk-lp:~/devops/devops-r-d/lecture-25$ aws eks delete-cluster --name my-eks-cluster
{
    "cluster": {
        "name": "my-eks-cluster",
        "arn": "arn:aws:eks:eu-west-3:817539924586:cluster/my-eks-cluster",
        "createdAt": "2024-12-09T17:59:40.189000+02:00",
        "version": "1.31",
        "endpoint": "https://31748196FDB816AAD9D973C3AD795A5D.gr7.eu-west-3.eks.amazonaws.com",
        "roleArn": "arn:aws:iam::817539924586:role/EKS-devops-role",
        "resourcesVpcConfig": {
            "subnetIds": [
                "subnet-03cdb388b1946f040",
                "subnet-036bf72645a18b858"
            ],
            "securityGroupIds": [],
            "clusterSecurityGroupId": "sg-0204885a0a75b516d",
            "vpcId": "vpc-0ddcc1023b37a06e3",
            "endpointPublicAccess": true,
            "endpointPrivateAccess": false,
            "publicAccessCidrs": [
                "0.0.0.0/0"
            ]
        },
        "kubernetesNetworkConfig": {
            "serviceIpv4Cidr": "172.20.0.0/16"
        },
        "logging": {
            "clusterLogging": [
                {
                    "types": [
                        "api",
                        "audit",
                        "authenticator",
                        "controllerManager",
                        "scheduler"
                    ],
                    "enabled": false
                }
            ]
        },
        "identity": {
            "oidc": {
                "issuer": "https://oidc.eks.eu-west-3.amazonaws.com/id/31748196FDB816AAD9D973C3AD795A5D"
            }
        },
        "status": "DELETING",
        "certificateAuthority": {
            "data": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJUE41UFltNlVIREV3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TkRFeU1Ea3hOVFU0TkRC
YUZ3MHpOREV5TURjeE5qQXpOREJhTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURQSGVDR25ESGdJUzhSU1ZDWGI2ZWduc0RQOWZoZUFXZ214SCt6WDlSaGZ2dXBuQnl6U
VMxU2VQS3kKTFRBMlM0YmJWNTl4ZW1NdFBHRmU3TE83dmw0ZWNVQXhUNG02YlByWXplU1AvNk40Tk84OFc2Zk84Q0c0bFJvagptQnNxQ2ttMXo3bEZMbVdHQXRtYzM2OHBzb3FsVTRHM0orNUVBRnhFYWI5bmlJTkMzR3MvQ3I1NUttRGQ3cSsrCldHajJuWmxkZ3
BhWW1wMWFEcTd0bWl3dXFxUW1FTnJ3S29XTFFaNzAyZHZoNDdKUUh4ei9vOXZYV2NwTzRDd1YKc1VmVnhmOThTOHhFR1ZuWmZTemVzRjBhWU9jNTR1b01HZmpZb0xzVHBnV0FLZ0hjM3Bka3gvMEY0MDMvQS96bApSY3A5RDVna1VHaGdjSXRwK1hqMnNXWXFtTUp
iQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJRSng3bUErNCt1dFhDb0VOc2VYU3BEbDNaTzFqQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJD
d1VBQTRJQkFRQ1ZsbjBxcjF3dgo5cVlLU0dJemdsNnhQa1htbGdIOStFdFdrRndvbjNVTi9zaGE5c29kV3NBeU40YnBMV0RZZy8vb3RYcHpCSlF5Cm1sbjJUZ3pQcHhPWXlRM0s3TnRmcTRnRDZHbGtOK05PcUpoMlBUQzRLaGQvclhRdDdneElERTZhekJCUFBnS
FMKQWVTVUdRTzhWZ0JWZm10MVM1aENyY0hOZWhVTDBmOFpQTElmdTV6aUVFSjZ5ZFpMaFZTaDFZNC9FZDhVaE9ERAo0K3pVWGR1VHQwc29lTGphOTZSWGQzS1RMem9mTGU0Tk1hdjcxQVliQ2d3RjZZdnhSTHJ2TkZmUzhHdkJhMGc1CjZRTyszdFNoQ1VTN3hQSk
RyajAzdXpEVW0wamZhOCtnWnVHNDJlLzRxUmkwazlGMVlwbnVTc1IzbnRTNTlSRncKYXhHMG9URkQ2RzNMCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
        },
        "platformVersion": "eks.12",
        "tags": {}
    }
}
(END)