* index_template.json: config the ElasticSearch index.
    * cprofile in mappings is a customized document type.
	* "includes" : ["doc.i","doc.d.k","doc.d.v"] because we want to hide other information in a cprofile.
	* "_ttl" : { "enabled" : true}, to make sure the index in elasticsearch will be expired when a document in couchbase is expired.
	* "index" : "not_analyzed", to avoid fuzzy queries
	* "type" : "nested", to combine segment key and segment value.

