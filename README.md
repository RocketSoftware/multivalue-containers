# multivalue-containers

This repository contains sample containers for MV platforms.

## List of Containers

### Universe-docker-container

This container is a sample of Universe running in a RockyLinux docker container
using best practices.  It uses persistent storage to both install Universe
and store accounts.  This means UVHOME is at /data/uv vs the default /usr/uv.

This docker demonstrates why you would want to store Universe in persistant 
storage vs the docker storage.  Normal docker storage will track all changes
to it's filesystem utilizing a layer system.  You do not want to put high write
applications or tools into this storage.  Universe UVHOME directory is one
of these since it has accounts and multiple log files.

Note: If you have Universe already installed on your workstation you will
need to either shut down UniRPC or change what port UniRPC listens on in
this docker project.  You do this by editing the docker-compose.yml file in
the universe directory.  Find the universe-server section and the port
section.  Change the line
- "31438:31438"
to something like
- "31439:31438"

This will make Docker expose UniRPC on your workstation as
localhost:31439 VS localhost:31438.  UniRPC in the container is
still listening on 31438 requiring no change inside the container.

To use this container follow these steps

1. cd to the universe-docker-container directory
2. docker compose build    - This will build the container
3. docker compose up       - This will start the container

After bringing the container up you will need to license Universe.  You can do
this three ways

1. Inside the docker container (Easiest way is to use docker desktop)
2. cd /data/uv
3. uv - Enter Licensing information

Or use the Universe Graphical Admin tool.  You will need to connect to localhost
31438.  If you changed this in docker-compose.yml you need to use that port.


