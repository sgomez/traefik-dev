#!/usr/bin/env bash

CONFIG=$(cat<<-EOF
[req]
req_extensions     = req_ext
distinguished_name = req_distinguished_name
prompt             = no

[req_distinguished_name]
commonName=developer.localhost

[req_ext]
subjectAltName   = @alt_names

[alt_names]
DNS.1  = developer.localhost
DNS.2  = *.developer.localhost
EOF
)

echo -n "Generating certificate..."

openssl req -x509 -newkey rsa:2048 -sha256 -nodes -days 3650 \
    -out certs/wildcard.localhost.crt -keyout certs/wildcard.localhost.key \
    -extensions req_ext -config <(echo "$CONFIG") > /dev/null 2> /dev/null

echo " done."

cd ~/.mozilla/firefox/
if [[ $(grep '\[Profile[^0]\]' profiles.ini) ]]
then PROFPATH=$(grep -E '^\[Profile|^Path|^Default' profiles.ini | grep -1 '^Default=1' | grep '^Path' | cut -c6-)
else PROFPATH=$(grep 'Path=' profiles.ini | sed 's/^Path=//')
fi

cd -

echo "Run the follow lines to trust certificate (in DEBIAN systems)."
echo "    (sudo) cp certs/wildcard.localhost.crt /usr/local/share/ca-certificates"
echo "    sudo update-ca-certificates --fresh"
echo "    certutil -d $HOME/.pki/nssdb -A -t \"C,,\" -n \"Wildcard Developer Localhost\" -i certs/wildcard.localhost.crt"
echo "    certutil -d $HOME/.mozilla/firefox/$PROFPATH -A -t \"C,,\" -n \"Wildcard Developer Localhost\" -i certs/wildcard.localhost.crt"
