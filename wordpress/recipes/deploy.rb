# AWS OpsWorks recipe to be executed when deploying a WordPress application.
#
# This should be run as an additional deployment recipe on a standarf PHP App layer.
#
# - Nothing to do at the moment!

node[:deploy].each do |application, deploy|
  unless deploy.has_key? :wordpress
    Chef::Log.info("Skipping wordpress::deploy for #{application} as it is not a WordPress app")
    next
  end
  Chef::Log.info("Running wordpress::deploy for #{application}")

  # Silence is golden.

end
