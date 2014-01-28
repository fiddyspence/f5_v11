Puppet::Type.newtype(:f5_v11_vlan) do
  @doc = "Manage F5 v11 vlan."

  apply_to_device

  ensurable

  newparam(:name, :namevar=>true) do
    desc "The vlan name."
  end

  newproperty(:tag) do
    desc "The vlan ID"
    validate do |value|
      unless value =~ /^\d+$/
        raise ArgumentError, "VLAN must be a number"
      end
    end
  end

end
