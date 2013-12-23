#!/usr/bin/env bash

# Vagrant bootstrap scripts are run as root, so $HOME and ~ refer to root's
# home of /root
#
# For this reason, I specify a separate VAGRANT_ROOT to be used where
# appropriate and chown it at the end of the script so user 'vagrant' will
# have access when the user actually logs in.
#
# This script sets up rbenv for bash. If you use sh or zsh it will need to
# be modified to handle those. I believe you just need to add the appropriate
# entries into your .bashrc equivalent for rbenv to initialize properly.
###########################

# Change this is *your* fork's clone url (https://github.com/[your_user_name]/gocongress.git)
gocongressGithubUrl="https://github.com/usgo/gocongress.git"

###########################

rbenvGithubUrl="https://github.com/sstephenson/rbenv.git"
rbenvBuildPluginGithubUrl="https://github.com/sstephenson/ruby-build.git"
rubyVersionUrl="https://raw.github.com/usgo/gocongress/master/.ruby-version"

###########################

VAGRANT_HOME="/home/vagrant"

rbenvDir="${VAGRANT_HOME}/.rbenv"
rbenvBinDir="${rbenvDir}/bin"
rbenvShimsDir="${rbenvDir}/shims"
rbenvPluginsDir="${rbenvDir}/plugins"

gocongressDir="${VAGRANT_HOME}/gocongress"

###########################################

function main() {
  installDependencies
  getCodeBase
  installBundlerAndGems
  giveOwnershipToVagrant
  configureRailsWithPostgres
  copyEnvironmentVariablesFile
  showFinishedMessage
}

function installDependencies() {
  addDependentRepositories

  apt-get update

  apt-get install -y emacs23-nox
  apt-get install -y git-core
  apt-get install -y build-essential # gcc, make, etc.
  apt-get install -y libxslt-dev
  apt-get install -y libxml2-dev
  apt-get install -y postgresql-9.2
  apt-get install -y libpq-dev # postgres libs
  apt-get install -y nodejs

  apt-get autoremove

  installRuby
}

function getCodeBase() {
  git clone "${gocongressGithubUrl}" "${gocongressDir}/"
  echo "* Cloned gocongress code base to ${gocongressDir}/"

  giveOwnershipToVagrant
}

function installBundlerAndGems() {
  gemfilePath="${gocongressDir}/Gemfile"

  su --login vagrant --command "${rbenvShimsDir}/gem install bundler"
  echo "* Bundler has been installed."

  su --login vagrant --command "${rbenvBinDir}/rbenv rehash"
  echo "* rbenv shims have been rehashed."

  su --login vagrant --command "${rbenvShimsDir}/bundle install --gemfile=${gemfilePath}"
  echo "* gems listed in ${gemfilePath} have been installed."
}

# This bootstrapping script is run as root, so change ownership of vagrant home directory
# and everything in it to vagrant user and group.
function giveOwnershipToVagrant() {
  chown -R vagrant:vagrant "${VAGRANT_HOME}/"
}

function configureRailsWithPostgres() {
  createPostgresUser
  createPostgresDatabases

  copyDefaultDbConfigToRails
}

function createPostgresUser() {
  su --login postgres -c "createuser --username=postgres --superuser vagrant"
}

function createPostgresDatabases() {
  #su --login vagrant -c "createdb --username=vagrant --locale=en_US.utf8 --encoding=UTF8 --template=template0 usgc_test"
  #su --login vagrant -c "createdb --username=vagrant --locale=en_US.utf8 --encoding=UTF8 --template=template0 usgc_dev"

  su --login vagrant -c "createdb --username=vagrant usgc_test"
  su --login vagrant -c "createdb --username=vagrant usgc_dev"
}

function copyDefaultDbConfigToRails() {
  cp "${gocongressDir}/config/database.example.yml" "${gocongressDir}/config/database.yml"

  giveOwnershipToVagrant
}

function copyEnvironmentVariablesFile() {
  cp "${gocongressDir}/.env.example" "${gocongressDir}/.env"

  giveOwnershipToVagrant
}

function showFinishedMessage() {
  echo
  echo "**************************************************************"
  echo "* Read the README.md to continue setting up your environment *"
  echo "**************************************************************"
  echo
}

function addDependentRepositories() {
  addPostgreSqlRepository
}

# Add postgresql repository and key to apt
# https://wiki.postgresql.org/wiki/Apt#Quickstart
function addPostgreSqlRepository() {
  echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

  echo "* Added postgresql repository and key to apt."
}

# Install rbenv and use it to install ruby version specified in repository.
# Uses git to install rbenv (which installs ruby), so git must be installed
# on the system in order to use this.
function installRuby() {
  installRbenv

  rubyVersion="$(wget --quiet -O - ${rubyVersionUrl})"
  echo "*** About to download and install ruby ${rubyVersion}"
  echo "*** This part can be slow, but feel free to worry after 15-20 mins :)"
  su --login vagrant --command "${rbenvBinDir}/rbenv install ${rubyVersion}"
  su --login vagrant --command "${rbenvBinDir}/rbenv global ${rubyVersion}"

  echo "* ruby ${rubyVersion} installed and set as default by rbenv."
}

# rbenv is a ruby version manager. It allows you to install and switch between many versions of ruby.
# https://github.com/sstephenson/rbenv#installation
function installRbenv() {
  git clone "${rbenvGithubUrl}" "${rbenvDir}/"
  echo "export PATH=\"${rbenvBinDir}\":\$PATH" >> "${VAGRANT_HOME}/.bashrc"
  echo 'eval "$(rbenv init -)"' >> "${VAGRANT_HOME}/.bashrc"

  giveOwnershipToVagrant

  su --login vagrant --command ". ${VAGRANT_HOME}/.bashrc" # Reload bashrc as vagrant so rbenv is available

  installRbenvPlugins

  echo "* rbenv and plugins installed."
}

# Install ruby-build (rbenv plugin) to provide "rbenv install" functionality
# https://github.com/sstephenson/ruby-build#installation
function installRbenvPlugins() {
  git clone "${rbenvBuildPluginGithubUrl}" "${rbenvPluginsDir}/ruby-build"

  giveOwnershipToVagrant
}

###########################

main
