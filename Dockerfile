# starting from a CentOS 7 base image.
FROM centos:7
MAINTAINER Rob Howard <howardro@ecu.edu>

# metadata about this Docker image.
LABEL name="ArcGIS for Server Advanced Enterprise" \
      version="10.3.1" \
      description="ArcGIS for Server is software that makes your geographic information available to others in your organization and optionally anyone with an Internet connection." \
      license="proprietary" \
      url="http://www.esri.com/software/arcgis/arcgisserver"

# update and install dependencies.
RUN yum -y update && \
    yum -y install gettext net-tools fontconfig freetype libXfont libXtst libXi libXrender mesa-libGL mesa-libGLU Xvfb 

# add the contents of the build directory to the /src directory of the image.
ADD . /src

# use Yelp's dumb-init because ArcGIS Server's init script will exit and spawn a few processes.
ADD http://github.com/Yelp/dumb-init/releases/download/v1.0.0/dumb-init_1.0.0_amd64 /bin/dumb-init
RUN chmod +x /bin/dumb-init

# make sure that the arcgis user account exists and that it has permission to modify files
# in the installation and source paths.
RUN /usr/sbin/useradd --create-home --home-dir /usr/local/arcgis --shell /bin/bash arcgis
RUN chown -R arcgis /src && chmod -R 700 /src && \
    chown -R arcgis /usr/local/arcgis && chmod -R 700 /usr/local/arcgis

# switch to the arcgis user account.
USER arcgis

# the path where ArcGIS for Server 10.3.1 should be installed.
ENV HOME /usr/local/arcgis

# install ArcGIS for Server 10.3.1 using slient installation.
RUN mv /src/init.sh /usr/local/arcgis && chmod +x /usr/local/arcgis/init.sh && \
    tar xvzf /src/ArcGIS_for_Server_Linux_1031_145870.gz -C /tmp/ && \
    rm /src/ArcGIS_for_Server_Linux_1031_145870.gz && \
    /tmp/ArcGISServer/Setup -m silent -l yes

# remove the temporary files created during the installation process.
RUN rm -rf /tmp/ArcGISServer

# expose ports used for connecting to services and other site machines
# but not ones that are used for internal purposes.
EXPOSE 4000 4001 4002 4003 6080 6443

CMD ["/bin/dumb-init", "/usr/local/arcgis/init.sh"]

