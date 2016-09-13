#!/bin/bash
screen="changeme"
pid=`ps aux | grep $screen | awk '{print $2}'`
directory="/directory/to/server"
javac="java -jar server.jar"
command="screen -A -m -d -S $screen $javac"
if ps ax | grep -v grep | grep $screen > /dev/null
then
    read -p "Server is running, do you want to stop your server? [Y/n]" resp
    if [[ "$resp" == "y" || "$resp" == "Y" ]]; then
        read -p "Do you want to restart the server? [Y/n]" resp2
        if [[ "$resp2" == "y" || "$resp2" == "Y" ]]; then
            echo "Restarting your server now, please wait 30 seconds!"
            sleep 30 && screen -S $screen -p 0 -X stuff "stop$(printf \\r)"
            screen -wipe
            eval "cd $directory && $command"
        else
            echo "Stopping your server now as requested."
            echo "Sending stop command, please wait 30 seconds!"
            sleep 30 && screen -S $screen -p 0 -X stuff "stop$(printf \\r)"
            screen -wipe
        fi
    fi
else
    echo "Starting your server now as requested."
    eval "cd $directory && $command"
fi
