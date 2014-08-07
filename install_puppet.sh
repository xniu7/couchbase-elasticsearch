yum -y install puppet
cp -r /vagrant/puppet/modules/* /etc/puppet/modules/
#puppet module install elasticsearch-elasticsearch --force --modulepath '/vagrant/puppet/modules'
#puppet module install puppetlabs-apt --force --modulepath '/vagrant/puppet/modules'
#puppet module install puppetlabs-stdlib --force --modulepath '/vagrant/puppet/modules'