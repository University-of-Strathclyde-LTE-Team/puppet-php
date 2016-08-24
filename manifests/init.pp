# == Class: php
# Installs PHP 
#
# === Parameters
# [*install_dir*] 
#  Specifies the directory into which PHP should be installed. Default:
#  /usr/local
# 
# [*version*] 
#  Specifies the version of PHP to install. Default: ??
# 
# [*install_url*]
#  Specifies the URL to download the PHP source from Default:
#  ???
# 
# [*apxs2*]
#  APXS. Default: /usr/local/apache2.2/bin/apxs
# 
# [*libdir*]
# 
# [*gd*]
# [*config_file*]
# [*ldap*]
# [*openssl*]
# [*curl*]
# [*xmlrpc*]
# [*oci8*]
# [*jpegdir*]
# [*sockets*]
# [*pngdir*]
# [*mbstring*]
# [*zip*]
# [*soap*]]
# [*mysqli*]
# [*zlib*]
# [*opcache*]
# [*intl*]
# [*workingdir*]
#  Directory in which working takes place


include vcsrepo
class php (
    $working_dir     =    $php::params::working_dir,
    $install_dir     =    $php::params::install_dir,
    $install_url     =    $php::params::install_url,
    $version         =    $php::params::version,
    $apxs2           =    $php::params::axps2,
    $ldap            =    $php::params::ldap,
    $oci8            =    $php::params::oci8,
    $cli             =    $php::params::cli
) inherits ::php::params {
   
    anchor { 'php::begin': } ->
    class { '::php::install': } ->
    #class { '::php::config': } ~>
    #class { '::php::service': } ->
    anchor { 'php::end': }
    
}
