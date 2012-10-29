ios4me LGPL v3 Sources
=========================

About ios4me
------------

ios4me (also known as the Smart&Soft framework) is developed and maintained by [Smart&Soft](www.smartnsoft.com). We create cutting edge iOS and Android applications for our customers.

Its purpose is to speed up the development of iOS applications. We are constantly adding news features to it and you can also follow us on [twitter](https://twitter.com/#!/i0s4me)

Installation
------------

The Smart&Soft framework can simply be installed by going into the SnSTemplates Folder and run the install-templates.sh script as a super user.

	cd SnSTemplates
	sudo bash ./install-templates.sh -f 

The reason this script needs to run as a super user is because the framework will be built from the ground up and will eventually be copied into your default framework folders (ex */Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS5.0.sdk/...*)

The script will locate those folders (there can be many of them) for you and install the framework in its correct place.

Start a SnS Project
-------------------

In XCode when you create a new project and after you have installed the framework and templates you will find a new iOS Category called SmartnSoftv1.0. 

Here you can choose to create either an iPad or iPhone Application the choice is yours. 

Should you have any questions feel free to contact us via [twitter](https://twitter.com/#!/i0s4me) or [mail](mailto:johan@smartnsoft.com)

