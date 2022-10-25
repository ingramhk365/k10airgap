HOST=registry
DOMAIN=example.local

sudo firewall-cmd --add-port=5000/tcp --permanent
sudo firewall-cmd --reload

sudo dnf install -y httpd-tools

sudo mkdir -p /opt/registry/{auth,certs,data}

sudo htpasswd -bBc /opt/registry/auth/htpasswd admin admin

sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout /opt/registry/certs/$HOST.$DOMAIN.key -subj "/C=US/ST=California/L=Irvine/O=Ingram Micro Inc./CN=*.$DOMAIN" -x509 -addext "subjectAltName=DNS:$DOMAIN,DNS:$HOST.$DOMAIN" -days 365 -out /opt/registry/certs/$HOST.$DOMAIN.crt

sudo cp /opt/registry/certs/$HOST.$DOMAIN.crt /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust
sudo trust list | grep -i $DOMAIN
