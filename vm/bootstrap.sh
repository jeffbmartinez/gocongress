#!/usr/bin/env bash

# Vagrant bootstrap scripts are run as root, so $HOME and ~ refer to root's
# home of /root
#
# For this reason, I specify a separate VAGRANT_ROOT to be used where
# appropriate and chown it at the end of the script so user 'vagrant' will
# have access when the user actually logs in.

githubRepoCloneUrl="https://github.com/jeffbmartinez/gocongress.git"

VAGRANT_HOME="/home/vagrant"

# Add postgresql repository and key to apt
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

#apt-get update

#apt-get install -y emacs23-nox
#apt-get install -y git-core
#apt-get install -y build-essential # gcc, make, etc.
#apt-get install -y libxslt-dev
#apt-get install -y libxml2-dev
#apt-get install -y postgresql-9.2
#apt-get install -y libpq-dev # postgres libs
#apt-get install -y nodejs

#apt-get autoremove

# Install rbenv (https://github.com/sstephenson/rbenv#installation)
git clone https://github.com/sstephenson/rbenv.git ${VAGRANT_HOME}/.rbenv
echo "export PATH=\"${VAGRANT_HOME}/.rbenv/bin\":\$PATH" >> ${VAGRANT_HOME}/.bashrc
echo 'eval "$(rbenv init -)"' >> ${VAGRANT_HOME}/.bashrc
su -l vagrant -c ". ${VAGRANT_HOME}/.bashrc" # Reload bashrc as vagrant so rbenv is available

# Install ruby-build (rbenv plugin) to provide "rbenv install" functionality
# https://github.com/sstephenson/ruby-build#installation
git clone https://github.com/sstephenson/ruby-build.git "${VAGRANT_HOME}/.rbenv/plugins/ruby-build"

# Install required ruby version
rubyVersion="$(wget --quiet -O - https://raw.github.com/usgo/gocongress/master/.ruby-version)"
su -l vagrant -c "${VAGRANT_HOME}/.rbenv/bin/rbenv install ${rubyVersion}"

# Get code base
gocongressDirectory="${VAGRANT_HOME}/work/gocongress"
git clone "${githubRepoCloneUrl}" "${gocongressDirectory}/"

# Install bundler and gems
cd "${gocongressDirectory}/"
"${VAGRANT_HOME}/.rbenv/versions/${rubyVersion}/bin/gem" install bundler
bundle install



# Script is run as root, so give ownership of vagrant home directory to vagrant user and group.
chown -R vagrant:vagrant "${VAGRANT_HOME}/"

echo
echo "**************************************************************"
echo "* Read the README.md to continue setting up your environment *"
echo "**************************************************************"
echo
