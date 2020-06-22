#!/usr/bin/env bash

source $IDF_PATH/export.sh >/dev/null

if [ -z "$WORKSPACE"];
then
    WORKSPACE=/workspace/source
fi

SDKCONFIG=$WORKSPACE/sdkconfig
SDKCONFIG_TEMPLATE=$WORKSPACE/sdkconfig.defaults
VERSION=`git -C $WORKSPACE describe`

echo "Version $VERSION"
echo "Current working dir $PWD"

if [ -z "$CONFIG_FILE" ];
then
    echo "No config file location set"
    exit 1
else
    echo "JSON config $CONFIG_FILE"
fi
echo "Removing SDKCONFIG $SDKCONFIG"

rm $SDKCONFIG 2> /dev/null 

DEVICES=( $(jq -r '.clients[].config.CONFIG_CUSTOM_DEVICE_ID' $CONFIG_FILE) )

echo "Home dir $HOME"

if [ -d "$HOME/.espressif" ]; then
    echo "Found esp tools on home dir"
else
    echo "Not found tools in home dir so adding link"
    ln -s /esp/.espressif/ $HOME
fi
source $IDF_PATH/export.sh

ln -s /esp/.espressif/ /root

for DEVICE in "${DEVICES[@]}"; do

    CONFIG_LINES=( $(jq --arg DEVICE "$DEVICE" '.clients[].config | select(.CONFIG_CUSTOM_DEVICE_ID == $DEVICE)' $CONFIG_FILE | grep CONFIG | awk -F'"' '{ printf "%s=\"%s\"\n",$2,$4 }' ) )
    CONFIG=( $(jq --arg DEVICE "$DEVICE" '.clients[].config | select(.CONFIG_CUSTOM_DEVICE_ID == $DEVICE)' $CONFIG_FILE | grep CONFIG | awk -F'"' '{ print $2 }' ) )

    for i in "${!CONFIG[@]}"; do
        if [ `grep -c "^${CONFIG[$i]}" $SDKCONFIG_TEMPLATE` -eq 1 ];
        then
            echo "Found ${CONFIG[$i]}"
            sed "/${CONFIG[$i]}/d" $SDKCONFIG_TEMPLATE >/dev/null
            echo "Deleted config line" 
        else 
            echo "Not found ${CONFIG[$i]} Adding  ${CONFIG_LINES[$i]}"
        fi
        echo "${CONFIG_LINES[$i]}" >> $SDKCONFIG_TEMPLATE
    done

    idf.py clean build > /dev/null

    mkdir -p $WORKSPACE/images/$DEVICE
    cp $SDKCONFIG $WORKSPACE/images/$DEVICE/
    echo $VERSION > $WORKSPACE/images/$DEVICE/VERSION.txt
    cp $WORKSPACE/build/phev-ttgo.bin $WORKSPACE/images/$DEVICE/
done

echo "Built `ls -1h $WORKSPACE/images/ | wc -l` Firmware files"