#!/bin/bash -e

if [ ! -f "$CONFIG_FILE" ]; then
    echo "config \"$CONFIG_FILE\" does not exist."
    exit 1
fi


COOKIEJAR=$(mktemp)
SITETMP=$(mktemp)

alias wget="wget --quiet --load-cookies $COOKIEJAR --save-cookies $COOKIEJAR"

MANGACOUNT=$(xml select -t -v "count(/config/manga)" $CONFIG_FILE)

for (( MANGAID=1; MANGAID<=${MANGACOUNT}; MANGAID++ ))
do
    MANGAURL=$(xml select -t -v "/config/manga[$MANGAID]/lastURL" $CONFIG_FILE)
    MANGANEW=$(xml select -t -v "/config/manga[$MANGAID]/lastURL/@new" $CONFIG_FILE || echo "")
    MANGADIR=$(xml select -t -v "/config/manga[$MANGAID]/dir" $CONFIG_FILE)
    
    mkdir -p "$MANGADIR"
    pushd "$MANGADIR"
        wget -O $SITETMP $MANGAURL
        NEXTMANGAURL=$(xmllint --html -xpath "string(//div[contains(@class, 'btn-navigation-chap')]/a[contains(@class, 'back')]/@href | //a[contains(@class,'navi-change-chapter-btn-next')]/@href)" $SITETMP)
        
        if [ -n "$MANGANEW" ]
        then
            NEXTMANGAURL=$MANGAURL
        fi
        
        if [ -n "$NEXTMANGAURL" ]
        then
            LASTURL=$(dl-manga.sh $NEXTMANGAURL)
                    
            xml ed --inplace \
                -u "/config/manga[$MANGAID]/lastURL" --value "$LASTURL" \
                -d "/config/manga[$MANGAID]/lastURL/@new" \
                -u "/config/manga[$MANGAID]/date" --value "$(date -Iseconds)" \
                $CONFIG_FILE
        fi
        
    popd
done