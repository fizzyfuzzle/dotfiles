#!/bin/bash
#
exec &> "${HOME}/wayvnc.log"
#
HEADLESS="${1:-HEADLESS-1}"
OUTPUTS_TO_RECONNECT=()

restore_outputs() {
    [[ ${#OUTPUTS_TO_RECONNECT[@]} -ge 1 ]] || return
    for OUTPUT in "${OUTPUTS_TO_RECONNECT[@]}"; do
        echo "ENABLE OUTPUT: ${OUTPUT}"
        swaymsg output "${OUTPUT}" enable
    done
    sleep 2
    echo "DISABLE OUTPUT: ${HEADLESS}"
    wayvncctl detach &>/dev/null
    swaymsg output "${HEADLESS}" disable
    OUTPUTS_TO_RECONNECT=()

    # Lock Session
    loginctl lock-session
}

collapse_outputs() {
    echo "ENABLE OUTPUT: ${HEADLESS}"
    swaymsg output "${HEADLESS}" enable
    wayvncctl attach "${WAYLAND_DISPLAY}"
    wayvncctl output-set "${HEADLESS}"
    sleep 2
    for OUTPUT in $(wayvncctl -j output-list | jq -r '.[] | select(.captured==false).name'); do
        echo "DISABLE OUTPUT: ${OUTPUT}"
        swaymsg output "${OUTPUT}" disable
        OUTPUTS_TO_RECONNECT+=("${OUTPUT}")
    done
}

connection_count_now() {
    local count=$1
    if [[ $count == 1 ]]; then
        collapse_outputs
    elif [[ $count == 0 ]]; then
        restore_outputs
    fi
}

start_wayvnc() {
    if ! pgrep -x "wayvnc" >/dev/null; then
        echo "STARTING WAYVNC"
        wayvnc -D 127.0.0.1 5900 &
        sleep 1
    fi
}

stop_wayvnc() {
    pid=$(pgrep -x "wayvnc")
    if [ -n "${pid}" ]; then
        echo "STOPPING WAYVNC (PID: ${pid})"
        kill "${pid}"
    fi
    echo "DONE"
    exit 0
}

# Only Start Once
if pgrep -x "wayvncctl" >/dev/null; then
    exit 0
fi

# Exit Traps
trap restore_outputs EXIT
trap stop_wayvnc SIGINT

# Start WayVNC
start_wayvnc

# Start WayVNC Controller
while IFS= read -r EVT; do
    case "$(jq -r '.method' <<<"$EVT")" in
        client-*onnected)
            count=$(jq -r '.params.connection_count' <<<"$EVT")
            connection_count_now "$count"
            ;;
        wayvnc-shutdown)
            echo "WAYVNC STOPPED"
            connection_count_now 0
            start_wayvnc
            ;;
        wayvnc-startup)
            echo "WAYVNC STARTED"
            ;;
        *)
            echo "EVENT: ${EVT}"
            ;;
    esac
done < <(wayvncctl --wait --reconnect --json event-receive)
