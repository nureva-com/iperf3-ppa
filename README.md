# iperf3-ppa
PPA repository for libgpiod 2.X linux library. Note that this PPA uses the 2.X version of the libgpiod library which is still in active development. This package is not related at all to the [libgpiod2 debian package](https://packages.debian.org/sid/libgpiod2) which uses 1.6.X of the library.

## Usage

To use this PPA:

``` bash
curl -s --compressed "https://nureva-com.github.io/iperf3-ppa/KEY.gpg" | gpg --dearmor | sudo tee /usr/share/keyrings/nureva-iperf3-archive-keyring.gpg
sudo curl -s --compressed -o /etc/apt/sources.list.d/nureva-iperf3.list "https://nureva-com.github.io/iperf3-ppa/nureva-iperf3.list"
sudo apt update
sudo apt-get install -y iperf3_3.2
```

The supported architectures are arm64, and amd64.

## Building the Packages

Run `./bin/build_deb.sh`. Copy the resulting .deb files under `$PWD/.wrk` to this directory.

## Updating/adding new Packages to the PPA

Put your new .deb files inside the git repo and run `./bin/generate.sh` to
update the files. Then commit and push to repo.
