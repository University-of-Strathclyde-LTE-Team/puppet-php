class php::config inherits php {
    file { 'copy_phpini':
        path => '/etc/php/php.ini',
        source => 'puppet:///modules/php/apache2-php.ini'
    }
}
