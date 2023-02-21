#!/usr/bin/env fish

if ! test -n "$P1_IP"
    echo 'The P1_IP variable must be set'
    exit 1
end

if ! test -n "$DB_IP"
    echo 'The DB_IP variable must be set'
    exit 1
end

if ! test -n "$DB_PORT"
    echo 'The DB_PORT variable must be set'
    exit 1
end

while true
    set data (
        curl --fail \
            --show-error \
            --silent \
            --connect-timeout 5 \
            --max-time 5 \
            "http://$P1_IP/api/v1/data"
    )

    set phase1 (echo $data | jq '."active_power_l1_w"')
    set phase2 (echo $data | jq '."active_power_l2_w"')
    set phase3 (echo $data | jq '."active_power_l3_w"')

    # The API reports the data in Kilowatt/hour, but we want a base unit so we
    # convert it to watts/hour.
    set consumed (echo $data | jq '."total_power_import_kwh" * 1000')
    set produced (echo $data | jq '."total_power_export_kwh" * 1000')

    echo "electricity phase1=$phase1,phase2=$phase2,phase3=$phase3,produced=$produced,consumed=$consumed" | ncat --udp $DB_IP $DB_PORT
    sleep 60
end
