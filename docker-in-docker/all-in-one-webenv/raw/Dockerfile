FROM ubuntu:18.04

RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update -y \
    && apt-get install -y apt-transport-https ca-certificates wget curl nano; \
    \
    cd ~ \
    && echo "$(dpkg --print-architecture)" \
    && wget -O docker.tgz https://download.docker.com/linux/static/edge/"$(uname -m)"/docker-18.05.0-ce.tgz \
    && tar --extract \
    --file docker.tgz \
    --strip-components 1 \
    --directory /usr/local/bin/; \
    rm docker.tgz; \
    dockerd -v; \
    docker -v; \
    \
    wget -O /usr/local/bin/modprobe \
    https://raw.githubusercontent.com/docker-library/docker/master/18.05/modprobe.sh; \
    chmod +x /usr/local/bin/modprobe; \
    # wget -O /usr/local/bin/docker-entrypoint.sh \
    # https://raw.githubusercontent.com/docker-library/docker/master/18.05/docker-entrypoint.sh; \
    \
    # the following scripts is for docker-in-docker(dind)
    \
    apt-get install -y btrfs-progs e2fsprogs iptables xfsprogs xz-utils pigz zfsutils; \
    # pigz: https://github.com/moby/moby/pull/35697 (faster gzip implementation)
    addgroup -S dockremap \
    && adduser -S -G dockremap dockremap \
    && echo 'dockremap:165536:65536' >> /etc/subuid \
    && echo 'dockremap:165536:65536' >> /etc/subgid \
    ; \
    # && DIND_COMMIT='52379fa76dee07ca038624d639d9e14f4fb719ff' \
    # wget -O /usr/local/bin/dind https://raw.githubusercontent.com/moby/moby/master/hack/dind \
    wget -O /usr/local/bin/dind https://raw.githubusercontent.com/moby/moby/master/hack/dind; \
    chmod +x /usr/local/bin/dind; \
    apt-get install -y iptables; \
    wget -O /usr/local/bin/dockerd-entrypoint.sh \
    https://raw.githubusercontent.com/docker-library/docker/master/18.05/dind/dockerd-entrypoint.sh \
    && chmod +x /usr/local/bin/dockerd-entrypoint.sh; \
    \
    \
    # cp /usr/local/bin/dockerd-entrypoint.sh /usr/local/bin/docker-entrypoint.sh; \
    { \
        echo "#!/bin/bash"; \
        echo ""; \
        echo "nohup sh $(which dockerd-entrypoint.sh) 1>~/dockerd.log 2>&1 &"; \
        echo ""; \
		echo "sleep 15"; \
		echo "docker rm -f mysql5 mysql8 redis4 laravel tomcat debian"; \
		echo "docker run --name redis4 -v /root/redis4_data:/data \\"; \
		echo "        --rm -d -p 6379:6379 redis:latest redis-server --appendonly yes "; \
		echo "docker run --name mysql5 \\"; \
	    echo "        -v /root/mysql5_data:/var/lib/mysql \\"; \
	    echo "        --rm -d -p 3305:3306 -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root \\"; \
	    echo "        -e MYSQL_DATABASE=admin -e MYSQL_USER=admin -e MYSQL_PASSWORD=admin \\"; \
		echo "        mysql:5 "; \
		# echo "docker run --name mysql8 \\"; \
		# echo "        -v /root/mysql8_data:/var/lib/mysql \\"; \
		# echo "        --rm -d -p 3308:3306 -e MYSQL_ROOT_PASSWORD=root \\"; \
		# echo "        -e MYSQL_DATABASE=admin -e MYSQL_USER=admin -e MYSQL_PASSWORD=admin \\"; \
		# echo "        mysql:latest "; \
		echo "docker run --name laravel --link mysql5 --link redis4 \\"; \
		echo "        --rm -d -p 81:80 -v /root/laravel:/var/www/html \\"; \
		echo "        registry.cn-beijing.aliyuncs.com/stable/201806:laravel-env "; \
		echo "docker run --name tomcat --link mysql5 --link redis4 \\"; \
		echo "        -v /root/tomcat/webapps:/usr/local/tomcat/webapps/webapps \\"; \
		echo "        --rm -d -p 8080:8080 tomcat:9-jre10 "; \
		# echo "docker run --name laravel --link mysql5 --link mysql8 --link redis4 \\"; \
		# echo "        --rm -d -p 81:80 -v /root/laravel:/var/www/html \\"; \
		# echo "        registry.cn-beijing.aliyuncs.com/stable/201806:laravel-env "; \
		# echo "docker run --name tomcat --link mysql5 --link mysql8 --link redis4 \\"; \
		# echo "        -v /root/tomcat/webapps:/usr/local/tomcat/webapps/webapps \\"; \
		# echo "        --rm -d -p 8080:8080 tomcat:9-jre10 "; \
		echo "docker ps -a && docker run --rm --name debian -it debian:stretch-slim"; \
        # echo "while ((1))"; \
        # echo "do"; \
        # echo "    sleep 3600"; \
        # echo "done"; \
    } > /usr/local/bin/docker-entrypoint.sh && chmod +x /usr/local/bin/docker-entrypoint.sh; \
    \
    \
    # curl -L https://github.com/docker/compose/releases/download/1.22.0-rc1/docker-compose-"$(uname -s)"-"$(uname -m)" \
    # > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose \
    wget -O /usr/local/bin/docker-compose \
    https://github.com/docker/compose/releases/download/1.22.0-rc1/docker-compose-"$(uname -s)"-"$(uname -m)" \
    && chmod +x /usr/local/bin/docker-compose

VOLUME /var/lib/docker

EXPOSE 2375
EXPOSE 81
EXPOSE 8080
EXPOSE 3305
EXPOSE 3306
# EXPOSE 3308
EXPOSE 6379
ENTRYPOINT ["docker-entrypoint.sh"]
