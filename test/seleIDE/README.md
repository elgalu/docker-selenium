# Selenium IDE

Run exported Selenium IDE scripts in Ruby

## Requisites
- See [.ruby-version](./.ruby-version)
- See [Gemfile](./Gemfile)

## Setup
    git@github.com:elgalu/seleIDE.git && cd seleIDE
    rvm install $(cat .ruby-version)
    rvm use $(cat .ruby-version)
    gem install rubygems-update
    gem update --system
    gem install bundler -v=1.13.2
    bundle install

## Export
Export the Selenium IDE Script as **Ruby / Rspec / Remote webdriver**

## Run
    RUBYOPT=W0 bundle exec ./seleIDE *.rb

To run without [docker-selenium](https://github.com/elgalu/docker-selenium) you can:

    java -jar selenium-server-standalone-2.53.1.jar \
      -htmlSuite "*firefox /usr/lib/firefox/firefox" \
      "https://www.zalando.co.uk" \
      "DesktopTest.html" \
      "results.html"
