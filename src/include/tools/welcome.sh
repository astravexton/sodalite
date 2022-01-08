#!/usr/bin/env bash

if [[ $(realpath -s "$0") == "/usr/bin/sodalite-"* ]]; then
    . /usr/libexec/sodalite-common
else
    . "$(dirname "$(realpath -s "$0")")/common.sh"
fi

function check_update() {
    # Only run on Sodalite!
    if [[ -f "/usr/libexec/sodalite-common" ]]; then
        is_major_update=false
        is_minor_update=false
        ostree_ref="fedora/$(get_osrelease_property VERSION)/$(uname -p)/$(sodalite-get-variant id)"
        ostree_remote="zio" # TODO: Handle remote being named something else
        update_check_delay=$1
        update_check_file="$HOME/.sodalite_update_check"

        echo $ostree_ref

        if [[ -z $update_check_delay ]]; then
            update_check_delay=3600 # (1 hour)
        fi

        # TODO: Handle 3xx HTTP codes
        if { [[ "$(get_file_age $update_check_file)" -gt "$update_check_delay" ]] && [[ $(get_http_code "https://ostree.zio.sh") == "200" ]]; }; then
            if [[ -d "/ostree/repo/refs/remotes/$ostree_remote" ]]; then
                echo ":)"
            fi

            echo "check"

            touch $update_check_file
        fi
    fi
}

logo='  ____            _       _ _ _
 / ___|  ___   __| | __ _| (_) |_ ___
 \___ \ / _ \ / _` |/ _` | | | __/ _ \
  ___) | (_) | (_| | (_| | | | ||  __/
 |____/ \___/ \__,_|\__,_|_|_|\__\___|'
os_pretty=$(get_osrelease_item PRETTY_NAME)
os_ostree_version=$(get_osrelease_item OSTREE_VERSION)
hostname=$(hostname)

echoc "\e[1;36m$logo\033[0m"
echoc ""
echoc " Welcome to \e[1;36m$os_pretty\033[0m \e[0;36m($os_ostree_version)\033[0m on \e[1;36m$hostname\033[0m."

#check_update 0
