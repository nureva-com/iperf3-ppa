# iperf3-ppa
PPA repository for iperf 3.2 linux binary library.

## Usage

To use this PPA:

``` bash
curl -s --compressed "https://nureva-com.github.io/iperf3-ppa/KEY.gpg" | gpg --dearmor | sudo tee /usr/share/keyrings/nureva-iperf3-archive-keyring.gpg
sudo curl -s --compressed -o /etc/apt/sources.list.d/nureva-iperf3.list "https://nureva-com.github.io/ipefr3-ppa/nureva-iperf3.list"
sudo apt update
sudo apt-get install -y iperf3.2
```

The supported architectures are arm64, and amd64.

## Building the Packages

Run `./bin/build_deb.sh`. Copy the resulting .deb files under `$PWD/.wrk` to this directory.

## Updating/adding new Packages to the PPA

Put your new .deb files inside the git repo and run `./bin/generate.sh` to
update the files. Then commit and push to repo.
