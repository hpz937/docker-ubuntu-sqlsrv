FROM ubuntu:20.04
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    apt dist-upgrade --autoremove -y && \
	apt-get install -y vim curl git software-properties-common bash zsh
RUN add-apt-repository ppa:ondrej/php -y && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
	apt-get update && \
	ACCEPT_EULA=Y apt-get install php8.0 php8.0-dev php8.0-xml msodbcsql17 mssql-tools -y --allow-unauthenticated && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && \
	echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && \
	apt install unixodbc-dev -y
RUN pecl install sqlsrv && \
    pecl install pdo_sqlsrv && \
	printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini && \
	printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini && \
	phpenmod -v 8.0 sqlsrv pdo_sqlsrv

CMD ["bash"]
