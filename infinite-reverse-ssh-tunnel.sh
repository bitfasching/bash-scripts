#!/bin/bash

# Infinite Reverse SSH Tunnel
# nick@bitfasching.de, 2019

# mandatory command line arguments missing?
if [[ -z $3 ]]; then
	
	echo "Infinite Reverse SSH Tunnel"
	echo ""
	echo "Usage: $0 HOST PORT USER [REMOTE_LISTENING_PORT [FORWARDED_LOCAL_PORT [MORE_SSH_OPTIONS]]]"
	echo ""
	echo "Example for SSH'ing to hello@1.2.3.4:22 and forwarding local port 22 (SSH) to remote port 2222:"
	echo "$0 1.2.3.4 22 hello 2222 22"
	echo ""
	echo "Exit with (multiple) Ctrl+C."
	echo "SSH might ask to confirm host key on first connection."
	echo "SSH might ask for a password on every reconnection if public key hasn't been authorized."
	exit 1

fi

# give command line arguments a name
HOST=$1
PORT=$2
USER=$3
REMOTE_LISTENING_PORT=$4
FORWARDED_LOCAL_PORT=$5
MORE_SSH_OPTIONS=$6

# set required but optional arguments if not yet set
if [[ -z $REMOTE_LISTENING_PORT ]]; then
	# listen on 2222 by default
	REMOTE_LISTENING_PORT=2222
fi
if [[ -z $FORWARDED_LOCAL_PORT ]]; then
	# forward SSH by default
	FORWARDED_LOCAL_PORT=22
fi

echo "Starting infinite SSH loop:"
echo "- Connect to $USER@$HOST:$PORT"
echo "- Forward local port $FORWARDED_LOCAL_PORT to remote port $REMOTE_LISTENING_PORT"

# loop to restart SSH on failures
while true; do
	
	# run SSH
	ssh -N \
	-o "ServerAliveInterval 30" \
	-o "ServerAliveCountMax 1" \
	-o "ExitOnForwardFailure yes" \
	-R $REMOTE_LISTENING_PORT:localhost:$FORWARDED_LOCAL_PORT \
	-p $PORT $USER@$HOST \
	$MORE_SSH_OPTIONS

	echo "Failed. Waiting to reconnect..."
	sleep 3

done

