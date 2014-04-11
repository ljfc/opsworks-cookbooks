# AWS OpsWorks recipe to be executed when deploying a WordPress application.
#
# This should be run as an additional deployment recipe on a standarf PHP App layer.
#
# - Symlinks the appropriate wp-config.php

node[:deploy].each do |application, deploy|

  unless deploy.has_key(:wordpress)
    Chef::Log.debug("Skipping wordpress::deploy for #{application} as it is not a WordPress app")
    next
  end

  # TODO Need to symlink the config file!

end
