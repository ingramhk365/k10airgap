VERSION=5.0.9
HOST=registry
DOMAIN=example.local

helm repo add kasten https://charts.kasten.io/
helm repo update && helm fetch kasten/k10 --version=$VERSION
sudo docker run --rm -it gcr.io/kasten-images/k10offline:$VERSION list-images
sudo docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock gcr.io/kasten-images/k10offline:$VERSION pull images 
sudo docker login http://$HOST.$DOMAIN -u admin -p admin
sudo docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v ${HOME}/.docker:/root/.docker gcr.io/kasten-images/k10offline:$VERSION pull images --newrepo $HOST.$DOMAIN:5000
#helm install k10 k10-5.0.9.tgz --namespace kasten-io --insecure-skip-tls-verify --set global.airgapped.repository=$HOST.$DOMAIN:5000 --set global.imagePullSecret=regcred
