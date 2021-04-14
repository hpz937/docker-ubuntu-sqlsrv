FROM ubuntu:20.04
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt dist-upgrade --autoremove -y && \
	apt-get install -y vim curl git software-properties-common bash zsh zip unzip
RUN add-apt-repository ppa:ondrej/php -y && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
	apt-get update && \
	ACCEPT_EULA=Y apt-get install php8.0 php8.0-dev php8.0-xml php8.0-curl php8.0-smbclient php8.0-gd php8.0-mbstring php8.0-zip php8.0-ssh2 msodbcsql17 mssql-tools -y --allow-unauthenticated && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
	apt install unixodbc-dev -y
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
mv composer.phar /usr/local/bin/composer
RUN pecl install sqlsrv && \
    pecl install pdo_sqlsrv && \
	printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/8.0/mods-available/sqlsrv.ini && \
	printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/8.0/mods-available/pdo_sqlsrv.ini && \
	phpenmod -v 8.0 sqlsrv pdo_sqlsrv
COPY openssl.cnf /etc/ssl/openssl.cnf

CMD ["bash"]
