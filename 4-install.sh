VERSION=5.0.9
HOST=registry
DOMAIN=example.local

kubectl create namespace kasten-io
kubectl create secret docker-registry myregistrykey --docker-server=registry.example.local:5000 --docker-username=admin --docker-password=admin --namespace=kasten-io
kubectl get secret --namespace kasten-io

helm install k10 k10-$VERSION.tgz --namespace kasten-io --set global.airgapped.repository=$HOST.$DOMAIN:5000 --set global.imagePullSecret=myregistrykey
