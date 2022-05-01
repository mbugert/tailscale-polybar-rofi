#!/bin/sh

ICON_ACTIVE=""
ICON_INACTIVE=""

status=$(curl --silent --fail --unix-socket /run/tailscale/tailscaled.sock http://tailscale/localapi/v0/status)

# bail out if curl had non-zero exit code
if [ $? != 0 ]; then
    exit 0
fi

# check if it's stopped (down)
if [ "$(echo ${status} | jq --raw-output .BackendState)" = "Stopped" ]; then
    echo "${ICON_INACTIVE} VPN down"
    exit 0
fi

# if an exit node is active, show its hostname
exit_node_hostname="$(echo ${status} | jq --raw-output '.Peer[] | select(.ExitNode) | .HostName')"
if [ -n "${exit_node_hostname}" ]; then
    echo "${ICON_ACTIVE} VPN ${exit_node_hostname}"
else
    echo "${ICON_ACTIVE} VPN up"
fi
