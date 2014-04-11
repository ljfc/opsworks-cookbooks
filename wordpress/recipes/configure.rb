# AWS OpsWorks recipe to be executed when configuring a WordPress application.
#
# This should be run as an additional configuration recipe on a standarf PHP App layer.
#
# - Creates an appropriate wp-config.php
# - Creates a cron job to call wp-cron.php


node[:deploy].each do |application, deploy|
  unless deploy.has_key? :wordpress
    Chef::Log.info("Skipping wordpress::configure for #{application} as it is not a WordPress app")
    next
  end
  Chef::Log.info("Running wordpress::configure for #{application}")


  # Create wp-config.php

  # WordPress requires authentication keys for security. They need to be the same across all our app servers.
  authentication_keys = {
    'AUTH_KEY' => deploy[:wordpress][:auth_key],
    'SECURE_AUTH_KEY' => deploy[:wordpress][:secure_auth_key],
    'LOGGED_IN_KEY' => deploy[:wordpress][:logged_in_key],
    'NONCE_KEY' => deploy[:wordpress][:nonce_key],
    'AUTH_SALT' => deploy[:wordpress][:auth_key],
    'SECURE_AUTH_SALT' => deploy[:wordpress][:secure_auth_key],
    'LOGGED_IN_SALT' => deploy[:wordpress][:logged_in_salt],
    'NONCE_SALT' => deploy[:wordpress][:nonce_salt]
  }

  template "#{deploy[:deploy_to]}/shared/wp-config.php" do
    source 'wp-config.php.erb'
    mode 0660
    group deploy[:group]

    if platform?('ubuntu')
      owner 'www-data'
    elsif platform?('amazon')
      owner 'apache'
    end

    variables({
      :database_name => deploy[:database].fetch(:database),
      :database_username => deploy[:database].fetch(:username),
      :database_password => deploy[:database].fetch(:password),
      :database_host => deploy[:database].fetch(:host),
      :authentication_keys => authentication_keys
    })

    only_if do
      deploy[:database].present? && File.directory?("#{deploy[:deploy_to]}/shared/")
    end
  end


  # Create cron job to call wp-cron.php

  # TODO Need to figure out how to find the correct domain to call wget on.
  # TODO Find out how to run this on just one machine? Or should it run on all of them?
  #cron "wordpress" do
  #  hour "*"
  #  minute "*/15"
  #  weekday "*"
  #  command "wget -q -O - http://localhost/wp-cron.php?doing_wp_cron >/dev/null 2>&1"
  #end

end
