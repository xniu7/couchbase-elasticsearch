class couchbaseelasticsearch{
  include couchbaseelasticsearch::couchbase
  include couchbaseelasticsearch::elasticsearch
  include couchbaseelasticsearch::xdcr
  include couchbaseelasticsearch::loaddata
}