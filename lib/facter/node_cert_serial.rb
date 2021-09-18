# @summary Get the serial number from the puppet node certificate

require 'puppet'
require 'openssl'

Facter.add(:node_cert_serial) do
  setcode do
    certfile = File.expand_path(Puppet.settings[:hostcert])
    cert = OpenSSL::X509::Certificate.new(File.read(certfile))
    cert.serial.to_i
  end
end
