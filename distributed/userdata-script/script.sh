 #!/bin/bash -ex
date > /tmp/image.log
yum update -y

# Install and configure FTP server
yum install -y vsftpd
cat << 'EOF' > /etc/vsftpd/vsftpd.conf
ftp_data_port=443
listen_port=443
anonymous_enable=NO
pasv_enable=YES
pasv_min_port=64000
pasv_max_port=64001
port_enable=YES
pasv_addr_resolve=YES
write_enable=YES
connect_from_port_20=YES
ascii_upload_enable=YES
local_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
userlist_enable=YES
userlist_file=/etc/vsftpd/user_list
userlist_deny=NO
pam_service_name=vsftpd
EOF

# Configure FTP
adduser badactor
echo 5VXcbio8D3nsly | passwd --stdin badactor
echo badactor | sudo tee –a /etc/vsftpd/user_list
mkdir -p /home/badactor/ftp/upload
chmod 550 /home/badactor/ftp
chmod 750 /home/badactor/ftp/upload
chown -R badactor: /home/badactor/ftp

# Add the public IP to vsftpd config
{ echo -n "pasv_address="; curl -sS "http://checkip.amazonaws.com"; } >> /etc/vsftpd/vsftpd.conf

# Start the ftp service and set it to launch when the system boots with the following
systemctl start vsftpd
systemctl enable vsftpd
systemctl status vsftpd > /tmp/vsfptd.status

# Start SSM Agent
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
