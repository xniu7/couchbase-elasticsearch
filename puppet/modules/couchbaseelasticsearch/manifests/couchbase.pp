class couchbaseelasticsearch::couchbase {
  include couchbaseelasticsearch::basic
  
  # downloading
  exec { "couchbase-server-source": 
    command => "/usr/bin/wget http://packages.couchbase.com/releases/2.5.0/couchbase-server-enterprise_2.5.0_x86_64.rpm",
    cwd => "/home/vagrant/",
    creates => "/home/vagrant/couchbase-server-enterprise_2.5.0_x86_64.rpm",
    require => Class['couchbaseelasticsearch::basic'],
    before => Package['couchbase-server']
  }
  
  # installation
  package { "couchbase-server":
    provider => rpm,
    ensure => installed,
    source => "/home/vagrant/couchbase-server-enterprise_2.5.0_x86_64.rpm"
  }
  
  # run service
  service {'couchbase-server':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require => Package['couchbase-server'] 
  }

  # init a couchbase cluster
  exec { "couchbase-cluster-init":
    path => ['/usr/bin:/bin'],
    command => "sleep 20 && /opt/couchbase/bin/couchbase-cli cluster-init -c localhost:8091 \
      			--cluster-init-username=Administrator \
      			--cluster-init-password=Mmtest \
      			--cluster-init-ramsize=1024",
    require => Service['couchbase-server'],
	logoutput => on_failure,
  }
  
  # init a couchbase node
  exec { "couchbase-node-init":
    command => "/opt/couchbase/bin/couchbase-cli node-init -c localhost:8091 \
				-u Administrator \
				-p Mmtest \
                --node-init-data-path=/opt/couchbase/var/lib/couchbase/data \
  				--node-init-index-path=/opt/couchbase/var/lib/couchbase/data",
	creates => "/opt/couchbase/var/lib/couchbase/data",
    require => Exec['couchbase-cluster-init'],
  }
  
  # init a bucket
  exec { "couchbase-bucket-init-cprofile-real":
    command => "/opt/couchbase/bin/couchbase-cli bucket-create -c localhost:8091 \
  				-u Administrator \
  				-p Mmtest \
         		--bucket=cprofile-real \
  				--bucket-type=couchbase \
         		--bucket-ramsize=256 \
  				--bucket-replica=1",
    require => Exec['couchbase-node-init'],
  }
  
  # init another bucket
  exec { "couchbase-bucket-init-cprofile-test":
    command => "/opt/couchbase/bin/couchbase-cli bucket-create -c localhost:8091 \
  				-u Administrator \
  				-p Mmtest \
         		--bucket=cprofile-test \
  				--bucket-type=couchbase \
         		--bucket-ramsize=256 \
  				--bucket-replica=1",
    require => Exec['couchbase-node-init'],
  }
  
  # configure the number of concurrent replications in xdcr
  exec { "couchbase-replication-config":
    command => "/usr/bin/curl -X POST \
				-u Administrator \
				-p Mmtest \
				http://localhost:8091/internalSettings \
				-d xdcrMaxConcurrentReps=8",
    require => Exec['couchbase-cluster-init']
  }
}