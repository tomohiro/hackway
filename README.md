Hackway [![Stillmaintained](http://stillmaintained.com/Tomohiro/hackway.png)](http://stillmaintained.com/Tomohiro/hackway)
================================================================================

[Hacker News](http://news.ycombinator.com/news) IRC Gateway


[![Dependency Status](https://gemnasium.com/Tomohiro/hackway.png)](https://gemnasium.com/Tomohiro/hackway)
[![Code Climate](https://codeclimate.com/github/Tomohiro/hackway.png)](https://codeclimate.com/github/Tomohiro/hackway)


Requirements
-------------------------------------------------------------------------------

- Ruby 1.9.3 or later


Installation
--------------------------------------------------------------------------------

### Bundler

```sh
$ git clone git://github.com/Tomohiro/hackeway.git
$ cd hackeway
$ bundle install --path vendor/bundle
```


Usage
--------------------------------------------------------------------------------

### Start the hackeway server

```sh
$ bundle exec hackeway
```

Example: Change listen IP address, port.

```sh
$ bundle exec hackeway --server 192.168.10.1 --port 16667
```


### Connect the hackeway

1. Launch a IRC client.(Limechat, irssi, weechat...)
2. Connect the server


#### Server options

If you want check the command-line options, following type command.

```sh
$ bundle exec hackeway --help
```

Option       | Value                              | Default
-----------  | ---------------------------------- | ----------
-p, --port   | Port number to listen              | 16706
-s, --server | Host name or IP address to listen  | localhost
-w, --wait   | Wait SECONDS between retrievals    | 360(sec)
-l, --log    | Log file                           | STDOUT



### Channels

Channel       | Description          | Auto join
------------  | -------------------- | ---------
`#hackernews` | Hacker News articles | yes


LICENSE
--------------------------------------------------------------------------------

&copy; 2013 Tomohiro TAIRA.
This project is licensed under the MIT license.
See LICENSE for details.
