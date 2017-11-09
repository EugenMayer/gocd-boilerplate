# WAT

This should be a ready to go, as vanilla as possible GoCD environment for you to start and test or for you to start extracting
a production stack from this docker-compose.

It shows a couple of `gocd/gocd-server` features, right now, the follwing things are pre-setup

## Profiles

## docker-compose.yml

A setup for [elastic-agents](https://github.com/gocd-contrib/docker-elastic-agents), so GoCD will start up Docker container for you
while you can define the Docker-Image of your type in your pipeline job.

Be aware this is :
  
  - not "agents running as container"
  - nor it it "an agent running a docker-engine to start and stop containers"
  
More, this lets GoCD handle the whole container lifecyle and also your material deployments into the docker-container,
which you select by defining the image you want to use.  

This is typically used to run the builder-patter, where you have build docker-image for each of your project/microservice
so an image which includes just the build tools to build the artifact and **not** to ran the miroservice.

Why doing that?:

- This is used to safely encapsulate all build-environments and lets you define exactly, in which environment you want to build
with which versions of compiles, libraries and what so ever.
- It lets you keep the actual agent ( actually there is no persistent agent anymore ) clean, so no need to install software on that manuall

## GoCD configuration for Elastic-Agent

Hint: I am assuming you run docker for mac / docker for windows or docker under linux, not docker-toolbox.
If you run docker-toolbox be sure to replace http://localhost with you `docker-machine ip`

1. Go to http://localhost:8153 - not login required
1. open http://localhost:8153/go/admin/plugins and click on `Docker Elastic Agent Plugin` ( the wheel icon )
1. Set `Go Server URL` to `https://gocd-server:8154` This can be your public domain you access GoCD in production
1. Set `Agent auto-register Timeout (in minutes)*` to `1`
1. Set `Maximum docker containers to run at any given point in time:*` to `5` for now ( you can go bigger anytime)
1. Set `Docker URI:* ` to `docker-engine:2375` - this is the tcp socket of the `docker-engine` service we started together with the `gocd-server` - have a look at the docker-compose.yml
1. Set `Use Private Registry` to `false` (for now)

Save the configuration. 

You can not run the already existing pipeline and then read on below

### This has already been done by importing a config.xml for you, but for the reference

Now we are going to create a Elastic-Agent Image which can be used in jobs.
Jobs cannot define images directly, they rather pick a elastic-agent-profile-id which then is a specific docker-image to run in.
You can have as many elastic-agents profiles as you like, so as many job specific docker-images as you like

1. http://localhost:8153/go/admin/elastic_profiles 
1. press add and 
1. Set `id` to `test`
1. Set `Docker Image` to `gocd/gocd-agent-alpine-3.6:v17.11.0` (you can have anything in here, see the notes below)

Save.

1. Now create a pipeline and add a `sh` job which does `ls && and` and save
1. edit the job again and go to job settings, should be http://localhost:8153/go/admin/pipelines/test/stages/defaultStage/job/defaultJob/settings
1. under `Elastic Profile Id` select `test`

You should already have a pipeline inside your pipilines referencing this image `test` in its job, which will just make an `ls && env`
Run it :)
