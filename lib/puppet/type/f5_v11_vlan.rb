Puppet::Type.newtype(:f5_v11_vlan) do
  @doc = "Manage F5 v11 vlan."

  apply_to_device

  ensurable

  newparam(:name, :namevar=>true) do
    desc "The vlan name."
  end

end
