#!/bin/bash -e

BASEURL=$1

COOKIEJAR=$(mktemp)
alias wget="wget --quiet --load-cookies $COOKIEJAR --save-cookies $COOKIEJAR"

function DLCHAPTER {
    CHAPTERURL=$1
    SITETMP=$(mktemp)

    wget -O $SITETMP $CHAPTERURL

    CHAPTERNAME=$(xmllint --html -xpath "string(//select[contains(@class, 'navi-change-chapter')]/option[@selected]/text())" $SITETMP | sed 's/\W/_/g')
    PANELURLS=$(xmllint --html -xpath "//div[contains(@class, 'container-chapter-reader')]/img/@src" $SITETMP | tr " " "\n" | awk -F '"' '{print $2}')
    FILENAME=$(xmllint --html -xpath "string(//div[contains(@class, 'info-top-chapter')]/h2/text() | //div[contains(@class, 'panel-chapter-info-top')]/h1/text())" $SITETMP | sed 's/\W/_/g')
    FILENAMECBZ=$FILENAME.cbz
    
    for PANELURL in $PANELURLS
    do
        PANELNAME=$(echo "$CHAPTERNAME   ${PANELURL##*/}" | sed 's/\W/_/g')
        
        wget --referer=$CHAPTERURL -O "$PANELNAME" "$PANELURL"
        
        if [ -z "$NO_CBZ" ] 
        then
            zip -rq "$FILENAMECBZ" "$PANELNAME"
            rm "$PANELNAME"
        fi
    done
    

    # return next chapter url 
    echo $(xmllint --html -xpath "string(//div[contains(@class, 'btn-navigation-chap')]/a[contains(@class, 'back')]/@href | //a[contains(@class,'navi-change-chapter-btn-next')]/@href)" $SITETMP )
}


while [ -n "$BASEURL" ]
do
    LASTURL=$BASEURL
    BASEURL=$(DLCHAPTER $BASEURL)
done 

echo $LASTURL