sudo dnf update -y
sudo dnf install -y yum-utils
sudo yum config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf update -y
sudo dnf repolist
sudo dnf remove -y podman buildah
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo docker version
sudo docker info
