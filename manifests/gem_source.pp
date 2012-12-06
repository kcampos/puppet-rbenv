# Install a gem under rbenv for a certain user's ruby version.
# Requires rbenv::compile for the passed in user and ruby version
#
define rbenv::gem_source(
  $user,
  $ruby,
  $gem_source    = $title,
  $home   = '',
  $root   = '',
  $ensure = present
) {

  # Workaround http://projects.puppetlabs.com/issues/9848
  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.rbenv", default => $root }

  rbenvgemsource {"${user}/${ruby}/${gem_source}/${ensure}":
    ensure    => $ensure,
    user      => $user,
    gemsource => $gem_source,
    ruby      => $ruby,
    rbenv     => "${root_path}/versions/${ruby}",
    require   => Exec["rbenv::compile ${user} ${ruby}"],
  }
}
