class couchbaseelasticsearch::loaddata{
	include couchbaseelasticsearch::xdcr
	
	file { '/opt/couchbase/lib/python/cbdocloader':
	  ensure  => file,
	  require => Class['couchbaseelasticsearch::xdcr'],
	}
	
	exec { "loaddata-test": 
	  command => "/opt/couchbase/bin/tools/cbdocloader /vagrant/data/test.zip \
					-u Administrator \
					-p Mmtest \
					-n localhost:8091 \
					-b cprofile-test",
	  require => File['/opt/couchbase/lib/python/cbdocloader'],
  	  logoutput => on_failure,  
    }

}
