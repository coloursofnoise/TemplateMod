NAMEPATTERN='[^[:alnum:] _-]'

NAMEARG=$1
while [ -z $MODNAME ]; do
    if [ -z $NAMEARG ]; then
        echo Enter Mod Name:
        read MODNAME
    else
        MODNAME=$NAMEARG
        unset NAMEARG
    fi

    # skip verification
    #break

    if [[ $MODNAME =~ $NAMEPATTERN ]]; then
        echo "!!! Name contains invalid characters.
Valid characters include \`a-zA-Z0-9 _-\`"
        unset MODNAME
    fi

    echo "Checking for duplicates..."
    if [ -z "$UPDATELIST" ]; then
        UPDATELIST=$(curl -s $(curl -s https://everestapi.github.io/modupdater.txt))
    fi
    for MOD in $UPDATELIST; do
        if [[ $MODNAME: == $MOD ]]; then
            echo "Name already in use!"
            unset MODNAME
            break
        fi
    done
done

find $(dirname "$0") -type f -not -path '*/[@.]*' -exec sed -i -e "s/\\\$MODNAME\\\$/$MODNAME/g" {} \;
for f in $(dirname "$0")/*; do mv "$f" "$(echo "$f" | sed s/\\\$MODNAME\\\$/$MODNAME/g)"; done
echo "Initialization Complete."
rm $0
