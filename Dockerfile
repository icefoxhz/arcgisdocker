# 基础镜像centos7
FROM centos:7
MAINTAINER huang zheng <huang8838@163.com>

# 安装依赖环境
RUN yum -y update && \
    yum -y install gettext net-tools fontconfig freetype libXfont libXtst libXi libXrender mesa-libGL mesa-libGLU Xvfb

# 把当前目录下文件拷贝到镜像的/src目录下
ADD . /src

# 建立arcgis用户，赋值权限
RUN /usr/sbin/useradd --create-home --home-dir /usr/local/arcgis --shell /bin/bash arcgis
RUN chown -R arcgis /src && chmod -R 700 /src && \
    chown -R arcgis /usr/local/arcgis && chmod -R 700 /usr/local/arcgis

# 切换到arcgis用户，接下来用arcgis用户操作
USER arcgis

# 创建文件夹
RUN mkdir -p /usr/local/arcgis/server/usr/directories && mkdir -p /usr/local/arcgis/server/usr/config-store

# 安装目录
ENV HOME /usr/local/arcgis

# 解压，删除原文件
RUN tar xvzf /src/ArcGIS_for_Server_Linux_1031_145870.tar.gz -C /tmp/ && \
    rm /src/ArcGIS_for_Server_Linux_1031_145870.tar.gz

# 使用静默安装，并破解
RUN /tmp/ArcGISServer/Setup -m silent -l yes -a /src/ArcgisServer103.ecp

# 删除安装文件
RUN rm -rf /tmp/ArcGISServer

# 暴露的端口
EXPOSE 4000 4001 4002 4003 6080 6443

# 启动执行
CMD ["/bin/bash", "/src/start.sh"]

