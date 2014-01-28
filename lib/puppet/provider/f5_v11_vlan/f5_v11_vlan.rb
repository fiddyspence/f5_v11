require 'puppet/provider/f5_v11'

Puppet::Type.type(:f5_v11_vlan).provide(:f5_v11_vlan, :parent => Puppet::Provider::F5_v11) do
  @doc = "Manages f5 v11 vlan"




  def self.instances
    response = transport.get('/mgmt/tm/net/vlan')
    instances = []
    Puppet.debug "#{response.code}"
    if response.code == '200'
      pre_output = JSON.parse(response.body)
      Puppet.debug "#{pre_output}"
      unless pre_output['currentItemCount'] == 0
        pre_output['items'].each do |item|
          instances << new(:ensure => :present, :name => item['name'])
        end
      end
    end
    instances
  end

  def self.prefetch(host)
    instances.each do |prov|
      if pkg = host[prov.name]
        pkg.provider = prov
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end
#  def exists?
#    response = transport.get("/mgmt/tm/net/vlan/#{resource[:name]}")
#    if response.code == '200'
#      true
#    else
#      false
#    end
#  end

  def create
    response = transport.post("/mgmt/tm/net/vlan",{"name" => "#{resource[:name]}"})
    if response.code == '200'
      true
    else
      false
    end
  end

  def destroy
    response = transport.delete("/mgmt/tm/net/vlan/#{resource[:name]}")
    if response.code == '200'
      true
    else
      false
    end
  end

end
