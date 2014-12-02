class rancid::git ($remote=undef) {
  exec { "setup-git":
    cwd     => $rancid::homedir_real,
    environment => ["HOME=${rancid::homedir_real}"],
    command => join([
      "git config --global user.email \"rancid@${::fqdn}\"",
      "git config --global user.name rancid"
    ], ';'),
    user    => $rancid::user_real,
    before  => Rancid::Router_db[$rancid::groups],
    require => Package[$rancid::packages],
    unless  => "grep email ${rancid::homedir_real}/.gitconfig"
  }

  if ($rancid::rancid_git_remote) {
    exec { 'rancid-add-git-remote':
      cwd         => $rancid::homedir_real,
      environment => ["HOME=${rancid::homedir_real}"],
      command     => "git remote add origin ${rancid::rancid_git_remote}",
      user        => $rancid::user_real,
      require     => [
        Package[$rancid::packages],
        Rancid::Router_db[$rancid::groups]
      ],
      unless      => "grep \"remote \\\"origin\\\"\" ${rancid::homedir_real}/.git/config"
    }
  }
}
