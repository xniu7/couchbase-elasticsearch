class couchbaseelasticsearch::xdcr {
  include couchbaseelasticsearch::couchbase
  include couchbaseelasticsearch::elasticsearch

  # init a xdcr server
  exec { "couchbase-xdcr-init":
    command => "/opt/couchbase/bin/couchbase-cli xdcr-setup \
  				-c localhost:8091 \
  				-u Administrator \
  	       		-p Mmtest \
          		--create \
          		--xdcr-cluster-name=ES \
          		--xdcr-hostname=localhost:9091 \
  			    --xdcr-username=Administrator \
  			    --xdcr-password=Mmtest",
    require => [Class['couchbaseelasticsearch::couchbase'],Class['couchbaseelasticsearch::elasticsearch']]
  }

  #xdcr-replication-mode=capi is important: version2 protocal is not allowed
  exec { "couchbase-xdcr-cprofile-real":
    path => ['/usr/bin:/bin'],
    command => "sleep 10 && /opt/couchbase/bin/couchbase-cli xdcr-replicate \
  				-c localhost:8091 \
  				-u Administrator \
  				-p Mmtest \
          		--create \
         		--xdcr-cluster-name=ES \
         		--xdcr-from-bucket=cprofile-real \
         		--xdcr-to-bucket=cprofile-real \
  				--xdcr-replication-mode=capi",
	logoutput => on_failure,
    require => [Exec['couchbase-xdcr-init']]
  }

  exec { "couchbase-xdcr-cprofile-test":
    path => ['/usr/bin:/bin'],
    command => "sleep 10 && /opt/couchbase/bin/couchbase-cli xdcr-replicate \
  				-c localhost:8091 \
  				-u Administrator \
  				-p Mmtest \
          		--create \
         		--xdcr-cluster-name=ES \
         		--xdcr-from-bucket=cprofile-test \
         		--xdcr-to-bucket=cprofile-test \
  				--xdcr-replication-mode=capi",
    require => [Exec['couchbase-xdcr-init']]
  }
}