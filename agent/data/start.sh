#!/bin/bash
DEBUG=false
# For debug
[ "$DEBUG" == 'true' ] && set -x
start_pid=$$
# A wrapper to trap the SIGINT signal (Ctrl+C) and forwards it to the background worker
# In other words : traps SIGINT and SIGTERM signals and forwards them to the child process as SIGTERM signals

asyncRun() {
    "$@" &
    pid="$!"
    trap "echo -e '\nStopping PID $pid'; kill -SIGTERM $pid;" SIGINT SIGTERM

    # A signal emitted while waiting will make the wait command return code > 128
    # Let's wrap it in a loop that doesn't end before the process is indeed stopped
    while kill -0 $pid > /dev/null 2>&1; do
        wait
    done
    trap - SIGINT SIGTERM
    sleep .5
    [ "$DEBUG" == 'true' ] && ps -a
    echo -e '\n\nBackground process was stopped';
    echo -e "Stop a script PID $start_pid\n"
    kill -SIGTERM "$start_pid"
}
mkdir -p /data/buildagent/
mkdir -p /data/logs/
chmod -R 777 /data/


if [ ! -f /data/logs/teamcity-agent.log ]; then
     touch /data/logs/teamcity-agent.log
     chmod 777 /data/logs/teamcity-agent.log
fi
# start services

asyncRun /run-services.sh & $@

ln -fs /opt/buildagent/ /data/buildagent/
tail -f /data/logs/teamcity-agent.log


