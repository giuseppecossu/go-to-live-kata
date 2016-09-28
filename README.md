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

This solution deploys WordPress on a simple 1-Tier architecture using an heat template. It includes an Apache server and a MySQL database. It works on Ubuntu 14.04 x86.

------------
Requirements
------------
To run the following template you need an OpenStack environment with the basic IaaS services, including neutron (OpenStack Networking) and Heat (OpenStack Orchestration).

-----------------------------------------
Heat OpenStack Template (HOT) description
-----------------------------------------

The heat template (wordpress-ubuntu-hot-template.yaml) requires the following parameters:
 * key_name: you need to create a keypair in your OpenStack environement and provide the keypair name
 * image_id: you need to provide an Ubuntu 14.04 x64 image name. If not available you need to add it in the glance (OpenStack image service) repository
 * public_network_id:  you need to provide the id of the external (aka public) network. It is required to create floating IPs.

Optionally the user can specify:
 * a WordPress version (you can select the latest 10 versions, https://wordpress.org/download/release-archive/)
  * latest, 4.6.1, 4.6, 4.5.4, 4.5.3, 4.5.2, 4.5.1, 4.5, 4.4.5, 4.4.4, 4.4.3
 * the MySQL cretentials
 * the WordPress db credentials

The template basically creates the following resources:
 * a private network
 * a security group allowing access only to ports 22 and 80
 * a router that connects the private network to the external network
 * an instance
 * a floating IP, providing public connectivity

Moreover the template installs Apache, MySQL and WordPress in the VM.

----------------------------------
Running the automated installation
----------------------------------

To run the template you can:
1. Use the OpenStack Dashboard, loading the template file into "Orchestration" -> "Stack".
2. Using the OpenStack CLI: e.g., heat stack-create -f wordpress-ubuntu-hot-template.yaml -P wordpress_version=4.6.1 -P key_name=wordpress-key -P image_id=Ubuntu-14.04-x64 wordpress-stack --poll 30

On the stack output you can find the WordPress URL and check the installation.

-----------------------------------------
Setup OpenStack CLI and run a simple test
-----------------------------------------

In this repository you can find two bash scripts:

**setup_test_environment.sh:** it sets up the OpenStack CLI using virtualenv, loads the OpenStack credentials, creates a keypair on OpenStack and add an Ubuntu14.04 image.
  usage: setup_test_environment.sh [[[-k keypairname] [-i imagename]] | [-h]]

**test_wordpress_template.sh:** launch the heat template and check if the Wordpress version is correctly installed.
  usage: setup_test_environment [[[-t templatefile ] [-k keypairname] [-i imagename] [-w wordpressversion] [-s stackname]] | [-h]]

