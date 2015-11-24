apt_repository 'sensu' do
  uri 'http://repositories.sensuapp.org/apt'
  distribution 'sensu'
  components ['main']
  key 'http://repositories.sensuapp.org/apt/pubkey.gpg'
end

package 'sensu'

execute 'chown -R sensu:sensu /etc/sensu'
