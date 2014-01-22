Puppet::Type.newtype(:f5_v11_vlan) do
  @doc = "Manage F5 v11 vlan."

  apply_to_device

  ensurable do
    desc "F5 vlan resource state. Valid values are present, absent."

    defaultto(:present)

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end
  end

  newparam(:name, :namevar=>true) do
    desc "The vlan name."
  end
end
