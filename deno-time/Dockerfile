FROM denoland/deno:alpine-1.31.1

WORKDIR /app

ADD . /app

RUN deno cache server.ts

EXPOSE 8000

# this command inherits the entrypoint from the base image
CMD ["run", "--allow-net", "server.ts"]
