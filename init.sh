NAMEPATTERN='[^[:alnum:] _-]'

while [ -z $MODNAME ]; do
    echo Enter Mod Name:
    read MODNAME
    if [[ $MODNAME =~ $NAMEPATTERN ]]; then
        echo "!!! Name contains invalid characters.
Valid characters include \`a-zA-Z0-9 _-\`"
        unset MODNAME
    fi
done

find $(dirname "$0") -type f -not -path '*/[@.]*' -exec sed -i -e "s/\\\$MODNAME\\\$/$MODNAME/g" {} \;
for f in $(dirname "$0")/*; do mv "$f" "$(echo "$f" | sed s/\\\$MODNAME\\\$/$MODNAME/g)"; done
