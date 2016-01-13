# ArcGIS Server on Docker

This repository is aimed at bringing ArcGIS for Server to the wonderful world of Linux containers, in this case
using Docker.

So, why use Docker? Honestly, because I had a running Docker host sitting next to my desk and felt like building
a container for ArcGIS for Server. This may not be the BEST way of accomplishing this goal. Also, I know some in
the Docker community shun containers with multple running processes; although, multple processes are a fact of life 
when dealing with closed-source 3rd party applications.

Please feel free to give feedback or submit bugfixes. Also, please note that this has NOT been tested very well
and that things will probably break. The entire thing comes with absolutely no warranty whatsoever.

Also, thank you to @hwernstrom for getting the ball rolling. I borrowed some from your code to get things started,
as shown by the fork indicator.

## Instructions

Getting ArcGIS for Server up and running with Docker is relatively easy using the files from this repository.
All that is required is a Linux machine with a working Docker installation and the proper ArcGIS for Server
tarball from Esri. Note, however, that any container created with the files in this repository will not
be authorized. You will need to authorize each container using an interactive session and the authorizeSoftware 
tool with a valid license file.

The steps are as follows:

1. Download the proper ArcGIS for Server Linux installation package from My Esri. Place this in the same
directory where your Dockerfile is located and ensure that the filename matches that used in the Dockerfile.

2. Execute `docker build .` in the directory with your Dockerfile. This part will take awhile to complete, so
don't lose faith.

3. Start a new Docker container with the image that you just created. For example:
```
docker run -d -it -p 6080:6080 --name=arcgis-server 911a768e08b7
```
_Note: Replace 911a768e08b7 with the ID of your Docker image, or better yet, your tag._

4. Your ArcGIS instance should now be running and listening on port 6080. Browse to 
http://<hostname>:6080/arcgis/manager in your web browser to verify that the instance is running.

5. If your instance is running, you may now authorize the software. To do this, you must connect to
the running container via an interactive shell after copying the authorization (`.ecp`) or 
provisioning file (`.prvc') into the container's filesystem.

```
docker cp ./provisioning.prvc arcgis-server:/usr/local/arcgis
docker exec -it arcgis-server bash
```

Next, you can use the interactive Bash shell to authorize the softare.

```bash
/usr/local/arcgis/server/tools/authorizeSoftware -f ../../provisioning.prvc -e email@domain.com
```

You should see a message such as this one once your software is authorized.
```
--------------------------------------------------------------------------
Starting the ArcGIS Software Authorization Wizard

Run this script with -h for additional information.
--------------------------------------------------------------------------
Product          Ver   ECP#           Expires
-------------------------------------------------
arcsdeserver     101   ecpXXXXXXXXX   29-jul-2016
svrenterprise    101   ecpXXXXXXXXX   29-jul-2016
arcgisserver     101   ecpXXXXXXXXX   29-jul-2016
schematicssvr    101   ecpXXXXXXXXX   29-jul-2016
capacitysvr_4    101   ecpXXXXXXXXX   29-jul-2016
svradvanced      101   ecpXXXXXXXXX   29-jul-2016
3dserver         101   ecpXXXXXXXXX   29-jul-2016
spatialserver    101   ecpXXXXXXXXX   29-jul-2016
networkserver    101   ecpXXXXXXXXX   29-jul-2016
imageextserver   101   ecpXXXXXXXXX   29-jul-2016
interopserver    101   ecpXXXXXXXXX   29-jul-2016
jtxserver        101   ecpXXXXXXXXX   29-jul-2016
geostatserver    101   ecpXXXXXXXXX   29-jul-2016
businesssvr      101   ecpXXXXXXXXX   29-jul-2016
highwayssvr      101   ecpXXXXXXXXX   29-jul-2016
geoeventsvr      101   ecpXXXXXXXXX   29-jul-2016
```

## What's next?

I may test this more thouroughly if I have a use case. Maybe not. I'll try to keep this repository up to date
with the latest ArcGIS releases if there is sufficient interest.