#!/bin/bash

function usage
{
    echo "usage: setup_test_environment.sh [[[-k keypairname] [-i imagename]] | [-h]]"
}

# Default values
keypairname=wordpress-key
imagename=Ubuntu-14.04-x64

while [ "$1" != "" ]; do
    case $1 in
        -k | --keypair-name )   shift
                                keypairname=$1 
                                ;;
        -i | --image-name )     shift
                                imagename=$1 
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Install OpenStack CLI on a python virtual env
sudo pip install virtualenv

# Create a working directory
mkdir openstack_cli
cd openstack_cli

# Start and use a virtualenv session
virtualenv venv
source venv/bin/activate

# Install pip requests
pip install requests

# Install OpenStack clients
pip install python-heatclient
pip install python-novaclient
pip install python-glanceclient
pip install python-neutronclient

cd ..
echo 'Loading OpenStack credentials'
source openrc

echo 'Creating Keypair'
nova keypair-add $keypairname > $keypairname.pem
chmod 600 $keypairname.pem

echo 'Adding Ubuntu 14.04 x64 image'
glance --os-image-api-version 1 image-create --name "Ubuntu-trusty-14.04-x64" --location https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare --is-public False

echo 'done!'
