class couchbaseelasticsearch::basic{
  # basic tools
  package { "wget":
    ensure => latest
  }

  package { "python":
    ensure => latest
  }

  package { "java-1.7.0-openjdk":
    ensure => latest
  }

  package { "curl":
    ensure => latest
  }
  
  package { "sed":
    ensure => latest
  }
}