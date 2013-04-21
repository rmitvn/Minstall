#!/bin/bash
# Install (Database): MySQL

# Package List Update Question
package_update_question

# Debian Specific Checks
check_repository_message "debian" "dotdeb" "DotDeb"

# Install Package
subheader "Installing Package..."
package_install mysql-server

# Set Password
subheader "Setting Password..."
if [ $UNATTENDED = 1 ]; then
	# Stop Daemon
	daemon_manage mysql stop

	# Start MySQL Server
	mysqld_safe --background --skip-grant-tables

	# Sleep
	sleep 2

	# Set Password
	mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('$(read_var_module root_password)') WHERE User='root'; FLUSH PRIVILEGES;"

	# Stop Daemon
	killall mysqld
fi

# Start Daemon
subheader "Starting Daemon..."
if [ $DISTRIBUTION = "centos" ]; then
	daemon_manage mysqld start
elif [ $DISTRIBUTION = "debian" ] || [ $DISTRIBUTION = "ubuntu" ]; then
	daemon_manage mysql start
fi
