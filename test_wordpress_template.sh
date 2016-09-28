#!/bin/bash

function usage
{
    echo "usage: test_wordpress_template [[[-t templatefile ] [-k keypairname] [-i imagename] [-w wordpressversion] [-s stackname]] | [-h]]"
}

# Default values
templatefile=wordpress-ubuntu-hot-template.yaml
keypairname=wordpress-key
imagename=Ubuntu-14.04-x64
wordpressversion=latest
stackname=wordpress-stack

while [ "$1" != "" ]; do
    case $1 in
        -t | --template-file )  shift
                                templatefile=$1
                                ;;
        -k | --keypair-name )   shift
                                keypairname=$1 
                                ;;
        -i | --image-name )     shift
                                imagename=$1 
                                ;;
        -w | --wordpress-version )   shift
                                wordpressversion=$1 
                                ;;
        -s | --stack-name )   shift
                                stackname=$1 
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

wordpressparameter=$wordpressversion

#The heat parameter needs "wordpress-" on the downloading url.
if [ $wordpressversion != 'latest' ]; then
 wordpressparameter=wordpress-$wordpressversion
fi

# Use virtualenv for OpenStack CLI
source openstack_cli/venv/bin/activate
# Load OpenStack Credentials
source openrc


echo 'Launching Heat Stack using the following parameters' 
echo 'heat stack-create -f' $templatefile '-P wordpress_version='$wordpressparameter '-P key_name='$keypairname' -P image_id=$imagename '$stackname '--poll 30'
echo ''

# Run Heat Template with the required parameters
heat stack-create -f $templatefile -P wordpress_version=$wordpressparameter -P key_name=$keypairname -P image_id=$imagename $stackname --poll 30
wait
wordpress_url=$(heat stack-show $stackname 2> /dev/null | awk -F '"' '{if ($2=="output_value"){print $4}}')

echo ''
echo 'You can find Wordpress on that url: ' $wordpress_url
echo ''

# Check version
detected_wordpress_version=$(curl $wordpress_url/readme.html 2> /dev/null | grep Version | awk -F 'Version ' '{print $2}')

echo ''
echo 'Detected WordPress version: ' $detected_wordpress_version
echo ''

#NOTE at the moment latest WordPress version is 4.6.1
if [ $wordpressversion == 'latest' ]; then
 echo  'You have correctly installed the Wordpress Version' $detected_wordpress_version 'check here https://wordpress.org/download/ if it is the latest version available.'
elif [ $wordpressversion == $detected_wordpress_version ]; then
 echo 'You have correctly installed the WordPress Version' $detected_wordpress_version
else
 echo 'Somenthing went wrong. You have installed WordPress Version ' $detected_wordpress_version ' instead of ' $wordpressversion '!'
fi

echo ''
echo 'Am I cheating? Look at this URL: ' $wordpress_url/readme.html
echo ''
