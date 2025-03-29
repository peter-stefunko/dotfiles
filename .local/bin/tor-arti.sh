#!/bin/bash
set -e

cleanup() {
    echo "Stopping the proxy..."
    kill $proxy_pid 2>/dev/null || true
    echo "Proxy stopped. Exiting script."
}

trap cleanup EXIT
timeout=3

echo "Starting Arti proxy"
arti proxy -l debug -p 9150 > /dev/null 2>&1 &
proxy_pid=$!
echo "Proxy started with PID $proxy_pid"

echo "Waiting $timeout seconds..."
sleep $timeout

echo "Starting Tor Browser"
TOR_PROVIDER=none TOR_SOCKS_PORT=9150 torbrowser-launcher &

echo "Waiting $timeout seconds"
sleep $timeout
echo "Waiting for Tor Browser to launch..."

while true; do
    browser_pid=$(ps -a | grep "firefox.real" | awk '{print $1}')
    if [ -n "$browser_pid" ]; then
        echo "Tor Browser is running with PID $browser_pid"
        break
    fi
    sleep 1
done

echo "Waiting for Tor Browser (PID $browser_pid) to close..."
while kill -0 $browser_pid 2>/dev/null; do
    sleep $timeout
done

echo "Tor Browser closed, stopping proxy"
kill $proxy_pid 2>/dev/null || true
