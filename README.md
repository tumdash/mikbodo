mikbodo
=====

**Mi**croservice based **bo**t platform for different services lile Telegram, Instagram etc

Build&Test
-----

    $ rebar3 clean compile ct

Build&Run Docker
----

```bash
$ docker build -f etc/Dockerfile -t 'mikbodo:latest' .
$ docker run -it -p 8888:8080 mikbodo
```

