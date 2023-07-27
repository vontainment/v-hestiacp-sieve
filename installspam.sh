#!/bin/bash

cp -r ./conf.d/20-spamham.conf /etc/dovecot/conf.d/20-spamham.conf
cp -r ./mail/. /var/mail/
cp -r ./sieve/. /etc/dovecot/sieve/
mkdir -p /var/mail/imapsieve_copy
mkdir -p /var/mail/imapsieve_copy/spam
mkdir -p /var/mail/imapsieve_copy/ham

chown -R mail:mail /var/mail
chmod -R 0775 /var/mail/imapsieve_copy
chmod 0755 /etc/dovecot/sieve/*
chmod 0775 /var/mail/sieve/
chmod 0644 /var/mail/sieve/*

service dovecot restart

# su -s /bin/bash debian-spamd -c "sa-learn --dump magic"

cat <<EOF | sudo tee /etc/cron.daily/spamham
#!/usr/bin/env bash
/etc/dovecot/sieve/scan_reported_mails
EOF

chmod 755 /etc/cron.daily/spamham && chown root:root /etc/cron.daily/spamham
