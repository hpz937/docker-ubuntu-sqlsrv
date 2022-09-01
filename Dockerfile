FROM ubuntu:20.04
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt dist-upgrade --autoremove -y && \
	apt-get install -y vim curl git software-properties-common bash zsh zip unzip sqlite3
RUN add-apt-repository ppa:ondrej/php -y && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
	apt-get update && \
	ACCEPT_EULA=Y apt-get install php8.1 php8.1-dev php8.1-xml php8.1-curl php8.1-smbclient php8.1-gd php8.1-mbstring php8.1-zip php8.1-ssh2 php8.1-sqlite3 msodbcsql17 mssql-tools -y --allow-unauthenticated && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
	apt install unixodbc-dev -y
RUN curl https://getcomposer.org/download/latest-stable/composer.phar > /tmp/composer.phar && \
    mv /tmp/composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer
RUN pecl install sqlsrv && \
    pecl install pdo_sqlsrv && \
	printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.1/mods-available/sqlsrv.ini && \
	printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.1/mods-available/pdo_sqlsrv.ini && \
	phpenmod -v 8.1 sqlsrv pdo_sqlsrv
COPY openssl.cnf /etc/ssl/openssl.cnf

CMD ["bash"]
