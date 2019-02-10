#!/bin/bash

# Purpose: VERY crude test control script to ease repetitive test steps

show_conf_file_contents() {

    declare -a conf_files

    conf_files=(
        "$HOME/.ssh/config"
        "$HOME/.ssh/known_hosts"
        "/etc/ssh/ssh_config"
        "/etc/ssh/known_hosts"
    )

    for file in "${conf_files[@]}"
    do
        clear
        echo "$file"
        if [[ -f "$file" ]]
        then
            tail $file
        else
            echo "$file not found"
        fi
        sleep 4
        echo
    done

}

echo "Installing roles ..."
ansible-galaxy install -r requirements.yml -p roles --force

show_conf_file_contents

echo "Running site.yml to spin up test environment ..."
ansible-playbook -i inventories/testing site.yml -K

show_conf_file_contents

echo "Running lxd-remove.yml to tear down test environment ..."
ansible-playbook -i inventories/testing lxd-remove.yml -K

