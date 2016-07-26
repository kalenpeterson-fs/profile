# == Class: profile::puppetwebsite
#
class profile::puppetwebsite (
  $web_root   = '/srv/puppet',
  $port       = 8000,
  $web_source = 'https://github.com/puppetlabs/exercise-webpage.git'
){

  # Ensure directory tree exists
  exec { 'mkdir_web_root':
    path    => '/bin:/usr/bin',
    command => "mkdir -p ${web_root}",
    creates => $web_root,
  }

  # Pull latest web source from github
  vcsrepo { $web_root:
    ensure   => latest,
    provider => git,
    source   => $web_source,
    revision => 'master',
    require  => Exec['mkdir_web_root'],
  }

  # Setup nginx
  class { '::nginx': }

  # Create a server definition for this website
  ::nginx::server { 'puppet':
    port     => $port,
    web_root => $web_root,
  }
}
