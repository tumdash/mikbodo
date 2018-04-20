FROM erlang:19

COPY src/* /mikbodo/src/
COPY test/* /mikbodo/test/
COPY rebar.config /mikbodo/

RUN cd /mikbodo/ && rebar3 compile && rebar3 ct && rebar3 release

EXPOSE 8080/tcp

ENTRYPOINT ["/mikbodo/_build/default/rel/mikbodo/bin/mikbodo", "foreground"]

