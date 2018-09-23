FROM bitwalker/alpine-elixir:1.7.3 as build
MAINTAINER Ivan Ilukhin <evanilukhin@gmail.com>

COPY . .

ENV MIX_ENV=prod
ENV APP_NAME="rock_bot"

RUN mix deps.get && \
    mix release



RUN RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export


FROM bitwalker/alpine-erlang:21

ENV MIX_ENV=prod
ENV REPLACE_OS_VARS=true

#Copy and extract .tar.gz Release file from the previous stage
COPY --from=build /export/ .

#Change user
USER default

#Set default entrypoint and command
ENTRYPOINT ["/opt/app/bin/rock_bot"]
CMD ["foreground"]
