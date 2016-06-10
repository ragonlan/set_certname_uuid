#!/usr/bin/ruby
### BEGIN INIT INFO
# Provides:          set_certname_uuid
# Required-Start:    puppet
# Default-Start:     2 3 4 5
### END INIT INFO

require 'iniparse'

return nil unless FileTest.exists?("/usr/sbin/dmidecode")
output=%x{/usr/sbin/dmidecode 2>/dev/null}
return if output.nil?

splitstr =  /^Handle/
uuid=''
output.split(splitstr).each do |line|
  if line =~ /[Ss]ystem [Ii]nformation/ and line =~ /\n\s+UUID: (.*)\n/
    uuid=$1.strip
    break
  end
end

if uuid
  document = IniParse.parse( File.read('/etc/puppet/puppet.conf') )
  document['main']['certname']=uuid.downcase
  document.save('/etc/puppet/puppet.conf')
end
