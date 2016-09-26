Go to live! kata
==================================

Contained in this repo, there are some instructions for a new application that will go live in the next month!

You will need to:

1. Fork this repository.

2. Automate the creation of the infrastructure and the setup of the application.

   You have only these instructions:

   2.1 It works on Ubuntu Linux 14.04 x64

   2.2 It's based on the last version of WordPress (it will be more useful if we can parameterize the version)

   2.3 You can choose Apache, Nginx or whatever you want

   For any other issues or question you will have to ask to the developers. In this case please ask us without problems :)

3. Once deployed, the application should be secure, fast and stable. Assume that the machine is running on the public Internet and should be hardened and locked down.

4. Make any assumptions that you need to. This is an opportunity to showcase your skills, so if you want to, implement the deployment process with any additional features, tools or techniques you'd like to.

5. We are evaluating solutions based on the architecture and quality of the deployment. Show us just how beautiful, clean and pragmatic your code can be.

6. Once your solution is ready, please send us the link of your project.

Automated solution for an OpenStack platform
============================================

This solution deploys Wordpress on a simple 1-Tier architecture using an heat template. It includes an Apache server and a Mysql database. It works on Ubuntu 14.04 x86.

-----------------------------------------
Heat OpenStack Template (HOT) description
-----------------------------------------

The heat template (wordpress-ubuntu-hot-template.yaml) requires the following parameters:
 * key_name: you need to create a keypair in your OpenStack environement and provide the keypair name
 * image_id: you need to provide an Ubuntu 14.04 x64 image name. If not available you need to add it in the glance (OpenStack image service) repository
 * public_network_id:  you need to provide the id of the external (aka public) network. It is required to create floating IPs.

Optionally the user can specify:
 * a WordPress version
 * the MySQL cretentials
 * the Wordpress db credentials

The template basically creates the following resources:
 * a private network
 * a security group allowing access only to ports 22 and 80
 * a router that connects the private network to the external network
 * an instance
 * a floating IP, providing public connectivity
