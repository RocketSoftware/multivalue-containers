# Universe Sample Docker Compose Project

This container is a sample of Universe running in a RockyLinux docker container
using best practices.  In this example universe is installed in the docker
storage area (/usr/uv).  This will allow you to rebuild the docker container
at any point but it will be a new clean universe install.  You will have to
relicense the machine and make any other changes.  In addition you will loose
anything that is stored in this directory such as your globally cataloged
items.  

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

1. Go to RBC and download the universe you wish to use and place it in
   shared-data/mv-install-file directory.
2. cd to the universe-docker-container directory
3. docker compose build    - This will build the container
4. docker compose up       - This will start the container

After bringing the container up you will need to license Universe.  You can do
this three ways

1. Inside the docker container (Easiest way is to use docker desktop)
2. cd /data/uv
3. uv - Enter Licensing information

Or use the Universe Graphical Admin tool.  You will need to connect to localhost
31438.  If you changed this in docker-compose.yml you need to use that port.

Notes

1. If you remove/rebuild your docker container you will loose everything in
   /usr/uv.  You can test installing Universe into the persistant storage
   by changing UVHOME to /data/uv in the Universe Dockerfile.  This will
   install Universe in the persistant area.  Be carefule rebuilding your
   container in this design, it will recognize Universe is already installed.
   You could temporarily change UVHOME back to the container and allow it to
   install Universe (or any other location) and then change it back to your
   actual location and restart the container.  This allows the installer
   to seed the required files into the container (/etc items, lib items, etc)

2. This project uses docker compose vs a direct docker run command.  This allows
   for a cleaner implementation and a framework to add additional containers.


