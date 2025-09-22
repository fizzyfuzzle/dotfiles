#!/bin/bash
#
HEADLESS="HEADLESS-1"
OUTPUTS_TO_RECONNECT=()

restore_outputs() {
    [[ ${#OUTPUTS_TO_RECONNECT[@]} -ge 1 ]] || return
    for output in "${OUTPUTS_TO_RECONNECT[@]}"; do
        echo "Re-enabling output $output"
        swaymsg output "$output" enable
    done
    echo "Disabling virtual output $HEADLESS"
    swaymsg output "$HEADLESS" disable
    OUTPUTS_TO_RECONNECT=()
}
trap restore_outputs EXIT

collapse_outputs() {
    echo "Switching to preexisting virtual output $HEADLESS"
    swaymsg output "$HEADLESS" enable
    wayvncctl output-set "$HEADLESS"
    for output in $(wayvncctl -j output-list | jq -r '.[] | select(.captured==false).name'); do
        echo "Disabling extra output $output"
        swaymsg output "$output" disable
        OUTPUTS_TO_RECONNECT+=("$output")
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

# Start WayVNC
if ! pgrep -x "wayvnc" > /dev/null; then
    wayvnc 127.0.0.1 5900 &
fi

# Start WayVNC Controller
while IFS= read -r EVT; do
    case "$(jq -r '.method' <<<"$EVT")" in
        client-*onnected)
            count=$(jq -r '.params.connection_count' <<<"$EVT")
            connection_count_now "$count"
            ;;
        wayvnc-shutdown)
            echo "wayvncctl is no longer running"
            connection_count_now 0
            exit 0
            ;;
        wayvnc-startup)
            echo "Ready to receive wayvnc events"
            ;;
    esac
done < <(wayvncctl --wait --reconnect --json event-receive)
