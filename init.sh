#!/bin/bash

# spawn the ArcGIS startup script in a new shell.
( exec /usr/local/arcgis/server/startserver.sh )

# sometimes it takes a while for everything to settle down.
# wait 5 seconds so that all processes are ready before beginning
# the wait loop.

echo "Waiting 5s for things to settle down..."

sleep 5

echo "ArcGIS Server Startup Completed..."

# loop until all java processes are finished.
while pgrep java > /dev/null; do
	sleep 0.5
done