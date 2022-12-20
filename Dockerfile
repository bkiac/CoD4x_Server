FROM unitymultiplay/linux-base-image:1.0.1

# Variables
ENV MAX_PLAYERS=12
ENV MAIN_SHARED=
ENV FS_GAME=
ENV CONFIG=server.cfg
ENV ARGS=

# Install dependencies.
USER root
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y lib32stdc++6
USER mpukgame

# Copy game files
COPY --chown=mpukgame bin/ cod4x-server
RUN chmod +x cod4x-server/cod4x18_dedrun

RUN mkdir cod4x-server/main

EXPOSE 28960

ENTRYPOINT cd cod4x-server && ./cod4x18_dedrun \
    +set net_port 28960 \
    +set dedicated 1 \
    +set sv_punkbuster 0 \
    +set sv_maxclients $MAX_PLAYERS \
    +set sv_cheats 0 \
    +map_rotate \
    +set fs_homepath . \
    +set fs_basepath ../cod4x-server-base \
    +set fs_game "$FS_GAME" \
    +exec "$CONFIG" \
    $ARGS
