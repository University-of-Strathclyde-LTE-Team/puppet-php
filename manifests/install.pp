# Class: php::install
#  Handles installation of PHP

class php::install inherits php {

    if ! defined(Class['php::params']) {
        fail('You must include the php::params class before using any apache defined resources')
    }

    package { 'git': 
        ensure => present
    }

    $syspackages = [ 'autoconf','bison', 'libxml2-dev', 'apache2-dev', 'systemtap-sdt-dev', 'openssl', 'pkg-config', 'libssl-dev', 'libcurl4-openssl-dev', 'libbz2-dev', 'libgdbm-dev', 'libjpeg62', 'libjpeg62-dev', 'libpng12-0', 'libpng12-dev', 'libfreetype6-dev', 'libicu-dev', 'libxslt1-dev']

    package { $syspackages:
        ensure => present,
        before => Exec['buildconf_php']
    }
    
    $srcdir = "${working_dir}/src"    
    info("working dir: ${working_dir}")
    info("source dir: ${srcdir}")

    
    file { "${working_dir}":
        ensure => 'directory'
    }
    
    file { "${working_dir}/src":
        ensure => 'directory'
    }
    
    vcsrepo  { $srcdir :
        ensure => present,
        provider => git,
        source => "${src_url}",
        revision => "PHP-${version}"
       #require     => File['github_id']
    }
    $with_apxs      =$apxs2     ? { false => "", default => "--with-apxs2=${apxs2}"}
    $with_libdir    =$libdir    ? { false => "", default => "--with-libdir=${libdir}"}
    $with_config_file_path   = $config_file_path  ? { false => "", default => "--with-config-file-path=${config_file_path}"}
    $with_gd        =$gd        ? { true => "--with-gd",        false => "", default => "${gd}"}
    $with_ldap      =$ldap      ? { true => "--with-ldap",      false => "", default => "--with-ldap=${ldap}"}
    $with_openssl   =$openssl   ? { true => "--with-openssl",   false => "", default => "--with-openssl=${openssl}"}
    $with_curl      =$curl      ? { true => "--with-curl",      false => "", default => "--with-curl=${curl}"}
    $with_xmlrpc    =$xmlrpc    ? { true => "--with-xmlrpc",    false => "", default => "--with-xmlrpc=${xmlrpc}"}
    $with_oci8      =$oci8      ? { true => "--with-oci8",      false => "", default => "--with-oci8=${oci8}"}
    $with_jpegdir   =$jpegdir   ? { true => "--with-jpeg-dir",   false => "", default => "--with-jpeg-dir=${jpegdir}"}
    $with_pngdir    =$pngdir    ? { true => "--with-png-dir",    false => "", default => "--with-png-dir=${pngdir}"}
    $with_sockets   =$sockets   ? { true => "--enable-sockets",   false => "", default => "--enable-sockets"}
    $with_mbstring  =$mbstring  ? { true => "--enable-mbstring",        false => "", default => "--enable-mbstring"}
    $with_zip       =$zip       ? { true => "--enable-zip",       false => "", default => "--enable-zip"}
    $with_soap      =$soap      ? { true => "--enable-soap",      false => "", default => "${soap}"}
    $with_mysqli    =$mysqli    ? { true => "--with-mysqli",    false => "", default => "--withmysqli=${mysqli}"}
    $with_zlib      =$zlib      ? { true => "--with-zlib",      false => "", default => "--with-zlib=${zlib}"}
    $with_opcache   =$opcache   ? { true => "",   false => "--disable-opcache", default => "${opcache}"}
    $with_intl      =$intl      ? { true => "--enable-intl",      false => "", default => "${intl}"}
    $disable_cli    =$cli       ? { true => "",    false => "--disable-cli", default => ""}

         
    $configurecmd = "${with_apxs} ${with_libdir} ${with_config_file_path} ${with_gd} ${with_ldap} ${with_openssl} ${with_curl} ${with_xmlrpc} ${with_oci8} ${with_jpegdir} ${with_pngdir} ${with_sockets} ${with_mbstring} ${with_zip} ${with_soap} ${with_mysqli} ${with_zlib} ${with_opcache} ${with_intl} ${disable_cli}"
    
    notice("Configure Command: ${configurecmd}")

    exec { 'buildconf_php':
       command => "./buildconf --force",
       cwd=> $srcdir,
       path=> "${srcdir}:/bin:/usr/bin"
    } ->

    exec { 'configure_php':
       command => "./configure ${configurecmd};",
       cwd=> $srcdir,
       path=> "${srcdir}:/bin:/usr/bin"
    } ->

    exec { 'build_php':
       command => "make -C ${srcdir}",
       cwd => $srcdir,
       path=> "${srcdir}:/bin:/usr/bin:/usr/sbin"
    } ->
    
    exec { 'libtoolfinish': 
       command => "libtool --finish ${srcdir}/libs",
       cwd => $srcdir,
       path=> "${srcdir}:/bin:/usr/bin:/usr/sbin"
    } ->

    exec { 'install_php':
       command => "make -C ${srcdir} install",
       cwd => $srcdir,
       path=> "${srcdir}:/bin:/usr/bin:/usr/sbin",
       creates=> '/usr/local/bin/php'
    } 
    
    file { 'php7.load':
        path => "${::apache::mod_enable_dir}/strathphp7.load",
        source => "puppet:///modules/php/apache_php7.load"
#        creates => "${::apache::mod_enable_dir}/php7.load"
    } 
    
    file { 'php.conf':
       path => "${::apache::mod_enable_dir}/strathphp7.conf",
       source => 'puppet:///modules/php/apache_php.conf'
 #      creates => "${::apache::conf_dir}/php.conf"
    }
    
}
