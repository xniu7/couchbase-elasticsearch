class couchbaseelasticsearch::elasticsearch {
  include couchbaseelasticsearch::basic
    
  # downloading
  exec { "elasticsearch-source": 
    command => "/usr/bin/wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.noarch.rpm",
    cwd => "/home/vagrant/",
    creates => "/home/vagrant/elasticsearch-1.0.1.noarch.rpm",
    require => Class['couchbaseelasticsearch::basic'],
    before => Package['elasticsearch']
  }

  # installation
  package { "elasticsearch":
    provider => rpm,
    ensure => installed,
    source => "/home/vagrant/elasticsearch-1.0.1.noarch.rpm"
  }

  # elastic search plugins
  exec { "transport-couchbase":
    command => "/usr/share/elasticsearch/bin/plugin -install transport-couchbase -url http://packages.couchbase.com.s3.amazonaws.com/releases/elastic-search-adapter/1.3.0/elasticsearch-transport-couchbase-1.3.0.zip",
    creates => "/usr/share/elasticsearch/plugins/transport-couchbase",
    require => [Package['elasticsearch'],Class['couchbaseelasticsearch::basic']],
    before => Service['elasticsearch']
  }

  exec { "elasticsearch-head":
    command => "/usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head",
    creates => "/usr/share/elasticsearch/plugins/head",
    require => [Package['elasticsearch'],Class['couchbaseelasticsearch::basic']],
    before => Service['elasticsearch']
  }
  
  
  exec { "elasticsearch-marvel":
    command => "/usr/share/elasticsearch/bin/plugin -i elasticsearch/marvel/latest",
    creates => "/usr/share/elasticsearch/plugins/marvel",
    require => [Package['elasticsearch'],Class['couchbaseelasticsearch::basic']],
    before => Service['elasticsearch']
 }

  # elastic search configs
  couchbaseelasticsearch::appendlinetofile { "couchbase-passwd":
    file => '/etc/elasticsearch/elasticsearch.yml',
    line => 'couchbase.password: Mmtest',
    require => Package['elasticsearch'],
    before => Service['elasticsearch'],
  }

  couchbaseelasticsearch::appendlinetofile { "couchbase-user":
    file => '/etc/elasticsearch/elasticsearch.yml',
    line => 'couchbase.username: Administrator',
    require => Package['elasticsearch'],
    before => Service['elasticsearch']
  }

  couchbaseelasticsearch::appendlinetofile { "couchbase-request-number":
    file => '/etc/elasticsearch/elasticsearch.yml',
    line => 'couchbase.maxConcurrentRequests: 1024',
    require => Package['elasticsearch'],
    before => Service['elasticsearch']
  }
  
  couchbaseelasticsearch::appendlinetofile { "couchbase-document-type":
    file => '/etc/elasticsearch/elasticsearch.yml',
    line => 'couchbase.defaultDocumentType: cprofile',
    require => Package['elasticsearch'],
    before => Service['elasticsearch']
  }
    
  service {'elasticsearch':
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    require => [Package['elasticsearch'],Class['couchbaseelasticsearch::basic']],
  }
  
  # couchbase-elasticsearch-plugin configs
  exec { "index-template":
    path => ['/usr/bin:/bin'],
    command => "sleep 10 && curl -X PUT http://localhost:9200/_template/couchbase -d @/vagrant/conf/index_template.json",
    require => Service["elasticsearch"],
	logoutput => on_failure,
  }
  /*
  exec { 'elasticsearch-restart':
    path => ['/sbin'],
    command => 'service elasticsearch restart',
	require => Exec["index-template"],
  }
  */
  
  # elasticsearch buckets
  exec { "cprofile-real":
    path => ['/usr/bin:/bin'],
    command => "sleep 10 && curl -X PUT http://localhost:9200/cprofile-real",
    require => Exec["index-template"],
  }
  
  exec { "cprofile-test":
    path => ['/usr/bin:/bin'],
    command => "sleep 10 && curl -X PUT http://localhost:9200/cprofile-test",
    require => Exec["index-template"],
  }
}