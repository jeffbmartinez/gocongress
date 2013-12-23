Gocongress
==========

A maintainable web app for the US Go Congress.
Copyright (c) 2013 American Go Association

[![Code Climate](https://codeclimate.com/github/usgo/gocongress.png)](https://codeclimate.com/github/usgo/gocongress)

Environment Setup
-----------------

You have two options, a virtual environment setup, or a local setup.

1. Virtual setup
    1. Requirements
        1. Read the local setup section anyway, just so you can see the steps that are automated for you in the virtual environment setup.
        1. Get [Vagrant][22]
        1. Get [VirtualBox][23]
        1. [Fork and clone][8] this github repo
    1. Point the bootstrap.sh script to your cloned repository
        1. Go to the .../gocongress/vm/ directory and open up bootstrap.sh
        1. Change the gocongressGithubUrl variable to the clone url of your forked gocongress github repository (something like "https://github.com/[your_user_name]/gocongress.git").
        1. Run "vagrant up" in the vm directory.
            * Depending on internet connection and machine speed, this can take a while.
            * This is creating a virtual Ubuntu 12.04 (32 bit) machine on your computer and then running a script to download and install all the dependencies necessary to run gocongress. If you're curious, that script lives at .../gocontress/vm/bootstrap.sh.
    1. When it's done setting up, point your browser to localhost:8080 and you should see the gocongress page.
        * This works because the local machine's port 8080 is forwarded to virtual machine's port 80, which is where the gocongress website is running
    1. Run "vagrant ssh" to ssh into the new virtual machine.
        * Your virtual machine username is vagrant (You can verify with "whoami" command)
        * There is another clone of your forked repo in ~/gocongress/ which is being used to serve the site on your physical machine's localhost:8080
        * type "exit" to leave the virtual machine.
    1. Get comfortable with Vagrant (and later VirtualBox if you find it necessary).
    1. Code away!
1. Local setup
    * Read the below "Contribute" section.

Contribute
----------

1. Prerequisites
    1. Linux (eg. [Ubuntu][15] 12.04+) or Mac OS 10.8+
    1. Proficiency with [git][13] and [sql][14]
    1. Read [Getting Started with Rails 3.2][16]
    1. [Fork and clone][8] this github repo
1. Install the Ruby version specified in `.ruby-version`.
    - Use [rbenv][9] or [compile from source][10]
1. Install [postgres 9.2][5]
    1. Practice connecting using the command-line client, `psql`
        - ["permission denied"][3]
        - [Client Connection Problems][4]
    1. Make sure you have a [role][19] that can create tables
1. App dependencies
    1. Install a js runtime
        - macs come with [JavaScriptCore][20] (part of webkit)
        - linux or mac: [node][11] (`apt-get nodejs`)
    1. Install ruby [gems][21] using [bundler][12]
        1. `gem install bundler`
        1. `bundle install`
        1. If a gem fails to install, it may be missing native libraries
            1. [nokogiri][17] needs libxml2 and libxslt
            1. [pg][18] needs libpq-dev
1. App configuration
    1. [Configure rails to talk to your database][6]
        1. `cp config/database.example.yml config/database.yml`
    1. `cp .env.example .env` (see Configuration below)
    1. If all is well, `bundle exec rake -T` should list rake tasks
1. Run the tests
    1. `bundle exec rake db:setup`
    1. `bundle exec rake test:prepare`
    1. `bundle exec rake` will run all specs and tests.  if they
       all pass, you're good to go
1. Submit your contribution
    1. Write a [spec][7] that describes your contribution
    1. Push your changes to your [fork][8] on github
    1. Submit a pull request

Configuration
-------------

`ENV` variables are stored in a `.env` file, which is git-ignored.
Most of these variables don't belong in source control because they
are secret.  Others vary by deployment level.  This file will be
loaded by the `dotenv` gem.

For local development, `cp .env.example .env` to get started.  I wish
we could use [foreman][1] to load `.env`, but it doesn't work with
`pry` or `guard` and it's overkill for one process.  For `stage` and
`production` use [heroku config][2].

Email for gocongress.org
------------------------

Email for accounts in the gocongress.org domain is managed through
google apps. jared.beck@usgo.org has access to manage these accounts.

Thanks
------

Special thanks to Lisa Scott, who helped invent, and tirelessly
tested, the first year's site in 2011.

* 2013: Chris Kirschner, Judy Debel
* 2012: Arlene Bridges, Bob Bacon, Steve Colburn
* 2011: Lisa Scott, Alf Mikula, Brian David, Andrew Jackson, Steve Colburn

[1]: http://blog.daviddollar.org/2011/05/06/introducing-foreman.html
[2]: https://devcenter.heroku.com/articles/config-vars
[3]: http://bit.ly/YJFlPQ
[4]: http://bit.ly/YJF4fK
[5]: http://www.postgresql.org/docs/9.2/interactive/
[6]: http://edgeguides.rubyonrails.org/configuring.html#configuring-a-database
[7]: https://www.relishapp.com/rspec
[8]: https://help.github.com/articles/fork-a-repo
[9]: https://github.com/sstephenson/rbenv
[10]: https://www.ruby-lang.org/en/downloads/
[11]: http://nodejs.org/
[12]: http://bundler.io/
[13]: http://git-scm.com/
[14]: http://www.postgresql.org/docs/9.2/static/sql.html
[15]: http://www.ubuntu.com/
[16]: http://guides.rubyonrails.org/v3.2.13/
[17]: http://nokogiri.org/tutorials/installing_nokogiri.html
[18]: https://bitbucket.org/ged/ruby-pg/wiki/Home
[19]: http://www.postgresql.org/docs/9.2/interactive/user-manag.html
[20]: http://trac.webkit.org/wiki/JavaScriptCore
[21]: http://guides.rubygems.org/
[22]: http://www.vagrantup.com/
[23]: https://www.virtualbox.org/
