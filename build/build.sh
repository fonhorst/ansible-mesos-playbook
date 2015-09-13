#!/bin/bash

# just a simple helper
function exec_command
{
    eval $1
    ERR=$?

    if [ "$ERR" != 0 ];
    then
        echo "Non-zero return code for command '$1': $ERR. Interrupt execution."
        exit 1
    fi
}

BOX_FILENAME=build.box
BOX_NAME="build/mesos-ubuntu"

exec_command "vagrant up --provision"
exec_command "vagrant halt"
exec_command "vagrant package --output $BOX_FILENAME"
exec_command "vagrant box add $BOX_FILENAME --force --name $BOX_NAME"
exec_command "vagrant destroy --force"
rm ../$BOX_FILENAME

