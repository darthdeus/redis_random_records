# Random Record with Ruby and Redis

This application is a solution for the [CloudSpokes Random Recrod with Ruby and Redis challenge](http://www.cloudspokes.com/challenges/1375).

It uses [Ohm](http://ohm.keyvalue.org/) for abstracting Redis into objects for easier manipulation.

To run, make sure you have Redis installed, and then simply run in the application's directory

    bundle install
    thin start

The demo application is hosted on [Heroku](http://heroku.com/) with [Redis To Go](http://redistogo.com/) addon.