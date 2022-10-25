HOST=registry
DOMAIN=example.local

sudo systemctl restart docker
sudo docker rm -fv $(docker ps -aq)

sudo docker run --name myregistry -p 5000:5000 \
 -v /opt/registry/data:/var/lib/registry:z \
 -v /opt/registry/auth:/auth:z \
 -e REGISTRY_AUTH=htpasswd \
 -e REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
 -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
 -v /opt/registry/certs:/certs:z \
 -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/$HOST.$DOMAIN.crt \
 -e REGISTRY_HTTP_TLS_KEY=/certs/$HOST.$DOMAIN.key \
 -e REGISTRY_COMPATIBILITY_SCHEMA1_ENABLED=true \
 -d docker.io/library/registry:latest

sudo sleep 5
sudo curl -u admin:admin -k https://$HOST.$DOMAIN:5000/v2/_catalog
sudo openssl s_client -connect $HOST.$DOMAIN:5000 -showcerts </dev/null 2>/dev/null|openssl x509 -outform PEM > myregistry-ca.crt
kubectl create configmap myregistry-ca -n openshift-config --from-file=$HOST.$DOMAIN..5000=myregistry-ca.crt
kubectl patch image.config.openshift.io/cluster --patch '{"spec":{"additionalTrustedCA":{"name":"myregistry-ca"}}}' --type=merge
#oc create configmap myregistry-ca -n kasten-io --from-file=$HOST.$DOMAIN..5000=myregistry-ca.crt
#oc patch image.config.openshift.io/cluster --patch '{"spec":{"additionalTrustedCA":{"name":"myregistry-ca"}}}' --type=merge

