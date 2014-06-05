name             "sugarpond_mysql_ssl"
maintainer       "YOUR_NAME"
maintainer_email "YOUR_EMAIL"
license          "All rights reserved"
description      "Installs/Configures sugarpond_mysql_ssl"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends "ssl"
depends "mysql", ">= 5.0"