# AWS OpsWorks recipte to be executed when configuring a server with Logentries support.
#
# This should be run as an additional configuration recipe on any layer which needs it.
#
# - Creates an additional /etc/rsyslog.d conf file
#
# Application logging is the responsible of the apps themselves, for example:
#
# - Use node[:apache][:error_log_destination] to tell apache to log errors to 'syslog:local7'


unless node.has_key? :logentries
  Chef::Log.info("Skipping logentries::configure as there are no Logentries logs provided")
else
  Chef::Log.info("Running logentries::configure")


  # Register the rsyslog service

  service 'rsyslog' do
    supports :restart => true, :reload => true, :status => true
    action   [:enable, :start]
  end


  # Create /etc/rsyslog.d/99-logentries.conf

  template "/etc/rsyslog.d/99-logentries.conf" do
    source 'logentries.conf.erb'
    mode 0644
    user 'root'
    group 'root'

    variables({
      :logentries => node[:logentries]
    })

    # Restart the rsyslog daemon.
    notifies :restart, 'service[rsyslog]'
  end

end
