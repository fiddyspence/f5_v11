# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#include f5_v11

f5_v11::config {'test':
  username => 'admin',
  password => 'admin',
  url      => '192.168.62.161',
  target   => '/etc/puppetlabs/puppet/device.conf',
}
