require 'puppet/provider/f5_v11'

Puppet::Type.type(:f5_v11_vlan).provide(:f5_v11_vlan, :parent => Puppet::Provider::F5_v11) do
  @doc = "Manages f5 v11 vlan"

  def self.instances
    response = transport.get('/mgmt/tm/net/vlan')
    if response.code == '200'
      pre_output = JSON.parse(response.body)
      pre_output['items'].each do |items|
        name = items['name']
        new(:name => name,
        :ensure => :present)
      end
    end
  end

  def exists?
    response = transport.get("/mgmt/tm/net/vlan/#{resource[:name]}")
    if response.code == '200'
      true
    else
      false
    end
  end

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
