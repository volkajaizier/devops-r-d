1. Download ready web site from the internet ocer-html
2. Create Dockerfile with nginx image and copy web-site folder to the /usr/share/nginx/html
3. Create an image from docker file 
docker build -t vlad-web .
docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
vlad-web     latest    09724ba4e6cd   43 minutes ago   283MB

save the image
docker save -o vlad-web_latest.tar vlad-web:latest

4.Create a docker-compose file with 2 replicas and image vlad-web(attached)
5.Create vagrant file with 3 machines master and 2 workers with preinstalled docker(attached)
6.SSH to all three machines, init docker swarm on master
docker swarm init --advertise-addr 192.168.1.100

and join 2 others machines

docker swarm join --token SWMTKN-1-4enl4j4ketnnufrn489371rtz0bbq9fj0x4cvt4yumymm47fet-ey6ry5h8nnspv6jczgdirsshk 192.168.1.100:2377

root@docker-master:~# docker node ls
ID                            HOSTNAME          STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
xcj07057jy6y5dtqjonijgjpo *   docker-master     Ready     Active         Leader           20.10.21
ql8df2zcij12l4fb5nll3s6uc     docker-worker     Ready     Active                          20.10.21
mzmnmp6mtnkbsymgwvk9sm1vu     docker-worker-2   Ready     Active                          20.10.21

7.Deploy a service
root@docker-master:/# docker stack deploy -c /vagrant/docker-compose.yml mywebsite
Creating network mywebsite_mynet
Creating service mywebsite_site

I`ve deployed 5 replicas
root@docker-master:~# docker service ps mywebsite_site
ID             NAME               IMAGE                            NODE              DESIRED STATE   CURRENT STATE           ERROR     PORTS
3ddgsuamk43y   mywebsite_site.1   vladv377350/vladvdevops:latest   docker-master     Running         Running 5 minutes ago
k0e86y189djl   mywebsite_site.2   vladv377350/vladvdevops:latest   docker-worker     Running         Running 5 minutes ago
m9nzbnqjkx5w   mywebsite_site.3   vladv377350/vladvdevops:latest   docker-worker-2   Running         Running 4 minutes ago
pfigbfd0inkb   mywebsite_site.4   vladv377350/vladvdevops:latest   docker-worker-2   Running         Running 4 minutes ago
usv1rqiuz2co   mywebsite_site.5   vladv377350/vladvdevops:latest   docker-worker     Running         Running 4 minutes ago

and than redeploy it docker compose with 3

root@docker-master:~# docker stack deploy -c /vagrant/docker-compose.yml --with-registry-auth mywebsite
Updating service mywebsite_site (id: lo7ir4jfwvncc15ybd3y8js1s)
root@docker-master:~# docker service ps mywebsite_site
ID             NAME               IMAGE                            NODE              DESIRED STATE   CURRENT STATE            ERROR     PORTS
3ddgsuamk43y   mywebsite_site.1   vladv377350/vladvdevops:latest   docker-master     Running         Running 14 minutes ago
k0e86y189djl   mywebsite_site.2   vladv377350/vladvdevops:latest   docker-worker     Running         Running 14 minutes ago
m9nzbnqjkx5w   mywebsite_site.3   vladv377350/vladvdevops:latest   docker-worker-2   Running         Running 13 minutes ago
pfigbfd0inkb   mywebsite_site.4   vladv377350/vladvdevops:latest   docker-worker-2   Remove          Running 1 second ago
usv1rqiuz2co   mywebsite_site.5   vladv377350/vladvdevops:latest   docker-worker     Remove          Running 1 second ago

8. Create a secret 
root@docker-master:~# echo "secret" > my_secret.txt
root@docker-master:~# cat my_secret.txt 
secret
root@docker-master:~# docker secret create my_secret my_secret.txt
v5qchptpwvixf3x98y7jo85v8

add secret to docker-compose

redeploy
root@docker-master:~# docker stack deploy -c /vagrant/docker-compose.yml --with-registry-auth mywebsite
Updating service mywebsite_site (id: lo7ir4jfwvncc15ybd3y8js1s)
root@docker-master:~# docker service ps mywebsite_site
ID             NAME                   IMAGE                            NODE              DESIRED STATE   CURRENT STATE                     ERROR     PORTS
uoz9pe5ycrug   mywebsite_site.1       vladv377350/vladvdevops:latest   docker-master     Running         Running 4 seconds ago
3ddgsuamk43y    \_ mywebsite_site.1   vladv377350/vladvdevops:latest   docker-master     Shutdown        Shutdown 6 seconds ago
pp2hbhrylxuw   mywebsite_site.2       vladv377350/vladvdevops:latest   docker-worker     Running         Starting less than a second ago
k0e86y189djl    \_ mywebsite_site.2   vladv377350/vladvdevops:latest   docker-worker     Shutdown        Shutdown 1 second ago
m9nzbnqjkx5w   mywebsite_site.3       vladv377350/vladvdevops:latest   docker-worker-2   Running         Running 20 minutes ago


root@docker-master:~# docker ps
CONTAINER ID   IMAGE                            COMMAND                  CREATED              STATUS              PORTS     NAMES
ed2f456760bf   vladv377350/vladvdevops:latest   "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp    mywebsite_site.1.uoz9pe5ycrugv5xrkahli3805
root@docker-master:~# docker exec -it ed2f456760bf cat /run/secrets/my_secret
secret


Problem I faced -> unfortunately I wasn`t able to reach site with the browser I tried local host(127.0.0.1 and public IP of vagrant workers) - > Please assist