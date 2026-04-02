sudo apt-get update && sudo apt-get install -y software-properties-common
sudo gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/buddy.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys eb39332e766364ca6220e8dc631c5a16310cc0ad
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/buddy.gpg] https://es.buddy.works/bdy/apt-repo prod main" | sudo tee /etc/apt/sources.list.d/buddy.list > /dev/null
sudo apt-get update && sudo apt-get install -y bdy && bdy tunnel TCP --token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJybmQiOjI3NjIwMjgxNTEyODAwMjM4LCJob3N0IjoiaHR0cHM6Ly9hcHAuYnVkZHkud29ya3MiLCJ3c0lkIjoxNzM2MjQsInYiOjN9.jjxyuTf_tPcbKojHklYTNdPfOusO3gjSbM52nwySA-k -n "tencuaban" "port ban muon mo"
